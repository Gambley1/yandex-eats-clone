import env from "dotenv"
// Replace if using a different env file or config.
env.config({ path: "./.env" })

import bodyParser from "body-parser"
import cors from "cors"
import express from "express"

import Stripe from "stripe"
import { generateResponse } from "./utils"

const stripePublishableKey = process.env.STRIPE_PUBLISHABLE_KEY || ""
const stripeSecretKey = process.env.STRIPE_SECRET_KEY || ""
const stripeWebhookSecret = process.env.STRIPE_WEBHOOK_SECRET || ""

const app = express()

app.use(cors())

app.use(
  (
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ): void => {
    if (req.originalUrl === "/webhook") {
      next()
    } else {
      /* @ts-ignore */
      bodyParser.json()(req, res, next)
    }
  }
)

const calculateOrderAmount = (items: string[] = []): number => {
  const total = items.reduce((sum, str) => sum + Number(str), 0)

  return total
}

function getKeys(payment_method?: string) {
  let secret_key: string | undefined = stripeSecretKey
  let publishable_key: string | undefined = stripePublishableKey

  switch (payment_method) {
    case "grabpay":
    case "fpx":
      publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_MY
      secret_key = process.env.STRIPE_SECRET_KEY_MY
      break
    case "au_becs_debit":
      publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_AU
      secret_key = process.env.STRIPE_SECRET_KEY_AU
      break
    case "oxxo":
      publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_MX
      secret_key = process.env.STRIPE_SECRET_KEY_MX
      break
    case "wechat_pay":
      publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_WECHAT
      secret_key = process.env.STRIPE_SECRET_KEY_WECHAT
      break
    case "paypal":
      publishable_key = process.env.STRIPE_PUBLISHABLE_KEY_UK
      secret_key = process.env.STRIPE_SECRET_KEY_UK
      break
    default:
      publishable_key = process.env.STRIPE_PUBLISHABLE_KEY
      secret_key = process.env.STRIPE_SECRET_KEY
  }

  return { secret_key, publishable_key }
}

app.post(
  "/pay-without-webhooks",
  async (
    req: express.Request,
    res: express.Response
  ): Promise<express.Response<any>> => {
    const {
      paymentMethodId,
      paymentIntentId,
      items,
      currency,
      useStripeSdk,
      cvcToken,
      email,
    }: {
      paymentMethodId?: string
      paymentIntentId?: string
      cvcToken?: string
      items: string[]
      currency: string
      useStripeSdk: boolean
      email?: string
    } = req.body

    const orderAmount: number = calculateOrderAmount(items)
    const { secret_key } = getKeys()

    const stripe = new Stripe(secret_key as string, {
      apiVersion: "2024-06-20",
      typescript: true,
    })

    try {
      if (cvcToken && email) {
        const customers = await stripe.customers.list({
          email,
        })

        // The list all Customers endpoint can return multiple customers that share the same email address.
        // For this example we're taking the first returned customer but in a production integration
        // you should make sure that you have the right Customer.
        if (!customers.data[0]) {
          return res.send({
            error:
              "There is no associated customer object to the provided e-mail",
          })
        }

        const paymentMethods = await stripe.paymentMethods.list({
          customer: customers.data[0].id,
          type: "card",
        })

        if (!paymentMethods.data[0]) {
          return res.send({
            error: `There is no associated payment method to the provided customer's e-mail`,
          })
        }

        const params: Stripe.PaymentIntentCreateParams = {
          amount: orderAmount,
          confirm: true,
          confirmation_method: "manual",
          currency,
          payment_method: paymentMethods.data[0].id,
          payment_method_options: {
            card: {
              cvc_token: cvcToken,
            },
          },
          use_stripe_sdk: useStripeSdk,
          customer: customers.data[0].id,
          return_url: "stripe-example://stripe-redirect",
        }
        const intent = await stripe.paymentIntents.create(params)
        return res.send(generateResponse(intent))
      } else if (paymentMethodId) {
        // Create new PaymentIntent with a PaymentMethod ID from the client.
        const params: Stripe.PaymentIntentCreateParams = {
          amount: orderAmount,
          confirm: true,
          confirmation_method: "manual",
          currency,
          payment_method: paymentMethodId,
          // If a mobile client passes `useStripeSdk`, set `use_stripe_sdk=true`
          // to take advantage of new authentication features in mobile SDKs.
          use_stripe_sdk: useStripeSdk,
          return_url: "stripe-example://stripe-redirect",
        }
        const intent = await stripe.paymentIntents.create(params)
        // After create, if the PaymentIntent's status is succeeded, fulfill the order.
        return res.send(generateResponse(intent))
      } else if (paymentIntentId) {
        // Confirm the PaymentIntent to finalize payment after handling a required action
        // on the client.
        const intent = await stripe.paymentIntents.confirm(paymentIntentId)
        // After confirm, if the PaymentIntent's status is succeeded, fulfill the order.
        return res.send(generateResponse(intent))
      }

      return res.sendStatus(400)
    } catch (e: any) {
      // Handle "hard declines" e.g. insufficient funds, expired card, etc
      // See https://stripe.com/docs/declines/codes for more.
      return res.send({ error: e.message })
    }
  }
)

// An endpoint to charge a saved card
// In your application you may want a cron job / other internal process
app.post("/charge-card-off-session", async (req, res) => {
  let paymentIntent, customer

  const { secret_key } = getKeys()

  const stripe = new Stripe(secret_key as string, {
    apiVersion: "2024-06-20",
    typescript: true,
  })

  try {
    // You need to attach the PaymentMethod to a Customer in order to reuse
    // Since we are using test cards, create a new Customer here
    // You would do this in your payment flow that saves cards
    customer = await stripe.customers.list({
      email: req.body.email,
    })

    // List the customer's payment methods to find one to charge
    const paymentMethods = await stripe.paymentMethods.list({
      customer: customer.data[0].id,
      type: "card",
    })

    // Create and confirm a PaymentIntent with the order amount, currency,
    // Customer and PaymentMethod ID
    paymentIntent = await stripe.paymentIntents.create({
      amount: calculateOrderAmount(),
      currency: "usd",
      payment_method: paymentMethods.data[0].id,
      customer: customer.data[0].id,
      off_session: true,
      confirm: true,
    })

    return res.send({
      succeeded: true,
      clientSecret: paymentIntent.client_secret,
      publicKey: stripePublishableKey,
    })
  } catch (err: any) {
    if (err.code === "authentication_required") {
      // Bring the customer back on-session to authenticate the purchase
      // You can do this by sending an email or app notification to let them know
      // the off-session purchase failed
      // Use the PM ID and client_secret to authenticate the purchase
      // without asking your customers to re-enter their details
      return res.send({
        error: "authentication_required",
        paymentMethod: err.raw.payment_method.id,
        clientSecret: err.raw.payment_intent.client_secret,
        publicKey: stripePublishableKey,
        amount: calculateOrderAmount(),
        card: {
          brand: err.raw.payment_method.card.brand,
          last4: err.raw.payment_method.card.last4,
        },
      })
    } else if (err.code) {
      // The card was declined for other reasons (e.g. insufficient funds)
      // Bring the customer back on-session to ask them for a new payment method
      return res.send({
        error: err.code,
        clientSecret: err.raw.payment_intent.client_secret,
        publicKey: stripePublishableKey,
      })
    } else {
      console.log("Unknown error occurred", err)
      return res.sendStatus(500)
    }
  }
})

app.listen(4242, (): void =>
  console.log(`Node server listening on port ${4242}!`)
)

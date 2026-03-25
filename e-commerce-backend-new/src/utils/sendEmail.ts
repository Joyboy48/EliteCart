import nodemailer from 'nodemailer';

interface SendEmailOptions {
  email: string;
  subject: string;
  message: string;
  html?: string;
}

// Core email sender — supports both plain text and HTML
const sendEmail = async (options: SendEmailOptions): Promise<void> => {
  try {
    const transporter = nodemailer.createTransport({
      host: process.env.SMTP_HOST,
      port: Number(process.env.SMTP_PORT),
      auth: {
        user: process.env.SMTP_USER,
        pass: process.env.SMTP_PASS,
      },
    });

    const mailOptions = {
      from: `"EliteCart 🛒" <${process.env.SMTP_FROM_EMAIL}>`,
      to: options.email,
      subject: options.subject,
      text: options.message,
      html: options.html,
    };

    await transporter.sendMail(mailOptions);
    console.log(`📧 Email sent to ${options.email}: "${options.subject}"`);
  } catch (error) {
    console.error('Error sending email:', error);
    throw new Error('Failed to send email');
  }
};

// ─── Order Confirmation Email ──────────────────────────────────────────────
interface OrderEmailData {
  orderId: string;
  totalAmount: number;
  paymentId: string;
  items?: any[];
  shippingAddress?: string;
}

export const sendOrderConfirmationEmail = async (
  email: string,
  order: OrderEmailData
): Promise<void> => {
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8" />
      <style>
        body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 0; }
        .container { max-width: 560px; margin: 40px auto; background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .header { background: #1a1a2e; padding: 28px 32px; text-align: center; }
        .header h1 { color: #fff; margin: 0; font-size: 24px; letter-spacing: 1px; }
        .header span { color: #e94560; }
        .body { padding: 32px; }
        .body h2 { color: #1a1a2e; font-size: 20px; margin-top: 0; }
        .detail-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
        .detail-row:last-child { border-bottom: none; }
        .label { color: #888; }
        .value { color: #222; font-weight: 600; }
        .badge { display: inline-block; background: #e8f5e9; color: #2e7d32; padding: 4px 12px; border-radius: 20px; font-size: 13px; font-weight: 600; }
        .footer { background: #f9f9f9; text-align: center; padding: 20px; font-size: 12px; color: #aaa; }
        .footer a { color: #e94560; text-decoration: none; }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="header">
          <h1>Elite<span>Cart</span> 🛒</h1>
        </div>
        <div class="body">
          <h2>Your order has been confirmed! 🎉</h2>
          <p style="color:#555; font-size:14px;">Thank you for shopping with EliteCart. Here's a summary of your order:</p>
          
          <div class="detail-row"><span class="label">Order ID</span><span class="value">${order.orderId}</span></div>
          <div class="detail-row"><span class="label">Payment ID</span><span class="value">${order.paymentId}</span></div>
          <div class="detail-row"><span class="label">Total Amount</span><span class="value">₹${order.totalAmount.toFixed(2)}</span></div>
          ${order.shippingAddress ? `<div class="detail-row"><span class="label">Ship To</span><span class="value">${order.shippingAddress}</span></div>` : ''}
          <div class="detail-row"><span class="label">Payment Status</span><span class="value"><span class="badge">✅ Paid</span></span></div>
          
          <p style="margin-top:24px; font-size:13px; color:#777;">Your order is being processed and will be shipped soon. You will receive a tracking update shortly.</p>
        </div>
        <div class="footer">
          <p>© ${new Date().getFullYear()} EliteCart. All rights reserved.</p>
          <p>Need help? <a href="mailto:${process.env.SMTP_FROM_EMAIL}">Contact Support</a></p>
        </div>
      </div>
    </body>
    </html>
  `;

  await sendEmail({
    email,
    subject: `✅ Order Confirmed — #${order.orderId} | EliteCart`,
    message: `Your order #${order.orderId} has been confirmed! Total: ₹${order.totalAmount}. Payment ID: ${order.paymentId}`,
    html,
  });
};

export default sendEmail;
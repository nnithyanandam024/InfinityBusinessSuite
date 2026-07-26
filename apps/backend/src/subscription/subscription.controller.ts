import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { SubscriptionService } from './subscription.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/subscription')
export class SubscriptionController {
  constructor(private subscriptionService: SubscriptionService) {}

  @Get('plans')
  async getPlans() {
    return this.subscriptionService.getPlans();
  }

  @UseGuards(JwtAuthGuard)
  @Post('create-razorpay-order')
  async createRazorpayOrder(@Request() req: any, @Body() body: { planId: string; billingCycle: 'MONTHLY' | 'YEARLY' }) {
    return this.subscriptionService.createRazorpayOrder(req.user.companyId, body.planId, body.billingCycle);
  }

  @UseGuards(JwtAuthGuard)
  @Post('verify-razorpay-payment')
  async verifyPayment(
    @Request() req: any,
    @Body() body: { razorpayOrderId: string; razorpayPaymentId: string; razorpaySignature: string },
  ) {
    return this.subscriptionService.verifyRazorpayPayment({
      companyId: req.user.companyId,
      ...body,
    });
  }
}

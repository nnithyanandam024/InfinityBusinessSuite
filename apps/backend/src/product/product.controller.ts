import { Controller, Get, Post, Put, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ProductService } from './product.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/products')
export class ProductController {
  constructor(private productService: ProductService) {}

  @Get('categories')
  async getCategories(@Request() req: any) {
    return this.productService.getCategories(req.user.companyId);
  }

  @Post('categories')
  async createCategory(@Request() req: any, @Body() body: { name: string; description?: string }) {
    return this.productService.createCategory(req.user.companyId, body);
  }

  @Get()
  async getProducts(@Request() req: any, @Query('search') search?: string) {
    return this.productService.getProducts(req.user.companyId, search);
  }

  @Get('barcode/:code')
  async getByBarcode(@Request() req: any, @Param('code') code: string) {
    return this.productService.getProductByBarcode(req.user.companyId, code);
  }

  @Post()
  async createProduct(@Request() req: any, @Body() body: any) {
    return this.productService.createProduct(req.user.companyId, body);
  }

  @Put(':id/stock')
  async updateStock(@Request() req: any, @Param('id') id: string, @Body() body: { delta: number }) {
    return this.productService.updateStock(req.user.companyId, id, body.delta);
  }

  @Delete(':id')
  async deleteProduct(@Request() req: any, @Param('id') id: string) {
    return this.productService.deleteProduct(req.user.companyId, id);
  }
}

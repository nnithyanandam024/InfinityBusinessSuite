import { Controller, Get, Post, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('api/users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get()
  async getUsers(@Request() req: any) {
    return this.usersService.getCompanyUsers(req.user.companyId);
  }

  @Post()
  async createEmployee(@Request() req: any, @Body() body: any) {
    return this.usersService.createEmployee(req.user.companyId, body);
  }

  @Delete(':id')
  async deleteUser(@Request() req: any, @Param('id') id: string) {
    return this.usersService.deleteUser(req.user.companyId, id);
  }
}

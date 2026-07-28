import { Module } from '@nestjs/common';
import { KhataService } from './khata.service';
import { KhataController } from './khata.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [KhataService],
  controllers: [KhataController],
  exports: [KhataService],
})
export class KhataModule {}

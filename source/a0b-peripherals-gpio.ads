--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Common definitions for STM32F2xx family [RM0033]
--
--  GPIO: General-purpose I/Os
--
--  It is generalized version to reuse by other MCUs.

pragma Ada_2022;

with A0B.STM32;
with A0B.Types;

package A0B.Peripherals.GPIO
  with Preelaborate, No_Elaboration_Code_All
is

   GPIO_MODER_Offset   : constant := 16#00#;
   GPIO_OTYPER_Offset  : constant := 16#04#;
   GPIO_OSPEEDR_Offset : constant := 16#08#;
   GPIO_PUPDR_Offset   : constant := 16#0C#;
   GPIO_IDR_Offset     : constant := 16#10#;
   GPIO_ODR_Offset     : constant := 16#14#;
   GPIO_BSRR_Offset    : constant := 16#18#;
   GPIO_AFR_Offset     : constant := 16#20#;  --  and 16#24#

   --------------
   -- GPIO_AFR --
   --------------

   type GPIO_AFR_AFR_Array is
     array (A0B.STM32.GPIO_Line_Identifier)
       of A0B.STM32.GPIO_Alternative_Function with Pack, Size => 64;

   type GPIO_AFR_Register is record
      AFR : GPIO_AFR_AFR_Array;
   end record with Size => 64;

   ---------------
   -- GPIO_BSRR --
   ---------------

   type GPIO_BSRR_BS_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of Boolean with Pack, Size => 16;

   type GPIO_BSRR_BR_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of Boolean with Pack, Size => 16;

   type GPIO_BSRR_Register is record
      BS : GPIO_BSRR_BS_Array;
      BR : GPIO_BSRR_BR_Array;
   end record with Size => 32;

   for GPIO_BSRR_Register use record
      BS at 0 range 0 .. 15;
      BR at 0 range 16 .. 31;
   end record;

   --------------
   -- GPIO_IDR --
   --------------

   type GPIO_IDR_IDR_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of Boolean with Pack, Size => 16;

   type GPIO_IDR_Register is record
      IDR            : GPIO_IDR_IDR_Array;
      Reserved_16_31 : A0B.Types.Reserved_16;
   end record with Size => 32;

   for GPIO_IDR_Register use record
      IDR            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   ----------------
   -- GPIO_MODER --
   ----------------

   type GPIO_MODER_MODER_Field is
     (Input,
      Output,
      Alternate,
      Analog) with Size => 2;

   type GPIO_MODER_MODER_Array is
     array (A0B.STM32.GPIO_Line_Identifier)
       of GPIO_MODER_MODER_Field with Pack, Size => 32;

   type GPIO_MODER_Register is record
      MODER : GPIO_MODER_MODER_Array;
   end record with Size => 32;

   --------------
   -- GPIO_ODR --
   --------------

   type GPIO_ODR_ODR_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of Boolean with Pack, Size => 16;

   type GPIO_ODR_Register is record
      ODR            : GPIO_ODR_ODR_Array;
      Reserved_16_31 : A0B.Types.Reserved_16;
   end record with Size => 32;

   for GPIO_ODR_Register use record
      ODR            at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   ------------------
   -- GPIO_OSPEEDR --
   ------------------

   type GPIO_OSPEEDR_OSPEEDR_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of A0B.STM32.GPIO_Output_Speed
       with Pack, Size => 32;

   type GPIO_OSPEEDR_Register is record
      OSPEEDR : GPIO_OSPEEDR_OSPEEDR_Array;
   end record with Size => 32;

   -----------------
   -- GPIO_OTYPER --
   -----------------

   type GPIO_OTYPER_OTYPER_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of A0B.STM32.GPIO_Output_Mode
       with Pack, Size => 16;

   type GPIO_OTYPER_Register is record
      OTYPER         : GPIO_OTYPER_OTYPER_Array;
      Reserved_16_31 : A0B.Types.Reserved_16;
   end record with Size => 32;

   for GPIO_OTYPER_Register use record
      OTYPER         at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   ----------------
   -- GPIO_PUPDR --
   ----------------

   type GPIO_PUPDR_PUPDR_Array is
     array (A0B.STM32.GPIO_Line_Identifier) of A0B.STM32.GPIO_Pull_Mode
       with Pack, Size => 32;

   type GPIO_PUPDR_Register is record
      PUPDR : GPIO_PUPDR_PUPDR_Array;
   end record with Size => 32;

   type GPIO_Registers is record
      GPIO_MODER   : GPIO_MODER_Register   with Volatile;
      GPIO_OTYPER  : GPIO_OTYPER_Register  with Volatile;
      GPIO_OSPEEDR : GPIO_OSPEEDR_Register with Volatile;
      GPIO_PUPDR   : GPIO_PUPDR_Register   with Volatile;
      GPIO_IDR     : GPIO_IDR_Register     with Volatile, Full_Access_Only;
      --  F2 requires word access, while some others (G4 for example) support
      --  byte/half word access.
      GPIO_ODR     : GPIO_ODR_Register     with Volatile;
      GPIO_BSRR    : GPIO_BSRR_Register    with Volatile, Full_Access_Only;
      --  F2 requires word access, while some others (G4 for example) support
      --  byte/half word access.
      GPIO_AFR     : GPIO_AFR_Register     with Volatile;
   end record;

   for GPIO_Registers use record
      GPIO_MODER   at GPIO_MODER_Offset   range 0 .. 31;
      GPIO_OTYPER  at GPIO_OTYPER_Offset  range 0 .. 31;
      GPIO_OSPEEDR at GPIO_OSPEEDR_Offset range 0 .. 31;
      GPIO_PUPDR   at GPIO_PUPDR_Offset   range 0 .. 31;
      GPIO_IDR     at GPIO_IDR_Offset     range 0 .. 31;
      GPIO_ODR     at GPIO_ODR_Offset     range 0 .. 31;
      GPIO_BSRR    at GPIO_BSRR_Offset    range 0 .. 31;
      GPIO_AFR     at GPIO_AFR_Offset     range 0 .. 63;
   end record;

end A0B.Peripherals.GPIO;

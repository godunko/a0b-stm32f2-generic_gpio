--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Generic GPIO controller driver for STM32F2+. It supports some later MCU
--  too.

pragma Restrictions (No_Elaboration_Code);

with A0B.GPIO;
with A0B.Peripherals.GPIO;

generic
   with procedure Enable_GPIO_Clock
     (Identifier : A0B.STM32.GPIO_Controller_Identifier);
   --  Enable clock of the given GPIO peripheral

   with procedure Disable_GPIO_Clock
     (Identifier : A0B.STM32.GPIO_Controller_Identifier);
   --  Disable clock of the given GPIO peripheral

package A0B.STM32.Generic_GPIO
  with Preelaborate
is

   type GPIO_Controller is tagged;

   type GPIO_Line
     (Controller : not null access GPIO_Controller'Class;
      Identifier : GPIO_Line_Identifier) is
        abstract limited new A0B.GPIO.Input_Line
          and A0B.GPIO.Output_Line with null record;

   procedure Initialize_Input
     (Self : aliased in out GPIO_Line'Class;
      Pull : GPIO_Pull_Mode := A0B.STM32.No);

   procedure Initialize_Output
     (Self  : aliased in out GPIO_Line'Class;
      Mode  : A0B.STM32.GPIO_Output_Mode  := A0B.STM32.Push_Pull;
      Speed : A0B.STM32.GPIO_Output_Speed := A0B.STM32.Low;
      Pull  : A0B.STM32.GPIO_Pull_Mode    := A0B.STM32.No);

   procedure Initialize_Alternative_Function
     (Self  : aliased in out GPIO_Line'Class;
      Line  : A0B.STM32.Function_Line_Descriptor;
      Mode  : A0B.STM32.GPIO_Output_Mode  := A0B.STM32.Push_Pull;
      Speed : A0B.STM32.GPIO_Output_Speed := A0B.STM32.Low;
      Pull  : A0B.STM32.GPIO_Pull_Mode    := A0B.STM32.No);

   overriding function Get (Self : GPIO_Line) return Boolean;

   overriding procedure Set (Self : GPIO_Line; To : Boolean);

   type GPIO_Controller
     (Peripheral : not null access A0B.Peripherals.GPIO.GPIO_Registers;
      Identifier : A0B.STM32.GPIO_Controller_Identifier)
        is abstract tagged limited null record;

end A0B.STM32.Generic_GPIO;

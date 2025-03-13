--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

package body A0B.STM32.Generic_GPIO is

   procedure Set_Pull_Mode
     (Self : aliased in out GPIO_Line'Class;
      To   : A0B.STM32.GPIO_Pull_Mode);

   procedure Set_Output_Speed
     (Self : aliased in out GPIO_Line'Class;
      To   : A0B.STM32.GPIO_Output_Speed);

   procedure Set_Output_Mode
     (Self : aliased in out GPIO_Line'Class;
      To   : A0B.STM32.GPIO_Output_Mode);

   ---------
   -- Get --
   ---------

   overriding function Get (Self : GPIO_Line) return Boolean is
   begin
      return Self.Controller.Peripheral.GPIO_IDR.IDR (Self.Identifier);
   end Get;

   -------------------------------------
   -- Initialize_Alternative_Function --
   -------------------------------------

   procedure Initialize_Alternative_Function
     (Self  : aliased in out GPIO_Line'Class;
      Line  : A0B.STM32.Function_Line_Descriptor;
      Mode  : A0B.STM32.GPIO_Output_Mode  := A0B.STM32.Push_Pull;
      Speed : A0B.STM32.GPIO_Output_Speed := A0B.STM32.Low;
      Pull  : A0B.STM32.GPIO_Pull_Mode    := A0B.STM32.No)
   is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

   begin
      Enable_GPIO_Clock (Self.Controller.Identifier);

      for Descriptor of Line loop
         if Descriptor.Controller = Self.Controller.Identifier
           and Descriptor.Line = Self.Identifier
         then
            Self.Set_Output_Speed (Speed);
            Self.Set_Output_Mode (Mode);
            Self.Set_Pull_Mode (Pull);

            Self.Controller.Peripheral.GPIO_AFR.AFR (Self.Identifier) :=
              Descriptor.Alternative_Function;

            Self.Controller.Peripheral.GPIO_MODER.MODER (Self.Identifier) :=
              A0B.Peripherals.GPIO.Alternate;

            return;
         end if;
      end loop;

      raise Program_Error;
   end Initialize_Alternative_Function;

   ----------------------
   -- Initialize_Input --
   ----------------------

   procedure Initialize_Input
     (Self : aliased in out GPIO_Line'Class;
      Pull : A0B.STM32.GPIO_Pull_Mode := A0B.STM32.No)
   is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

   begin
      Enable_GPIO_Clock (Self.Controller.Identifier);

      Self.Set_Pull_Mode (Pull);

      Self.Controller.Peripheral.GPIO_MODER.MODER (Self.Identifier) :=
        A0B.Peripherals.GPIO.Input;
   end Initialize_Input;

   -----------------------
   -- Initialize_Output --
   -----------------------

   procedure Initialize_Output
     (Self  : aliased in out GPIO_Line'Class;
      Mode  : A0B.STM32.GPIO_Output_Mode  := A0B.STM32.Push_Pull;
      Speed : A0B.STM32.GPIO_Output_Speed := A0B.STM32.Low;
      Pull  : A0B.STM32.GPIO_Pull_Mode    := A0B.STM32.No)
   is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

   begin
      Enable_GPIO_Clock (Self.Controller.Identifier);

      Self.Set_Output_Mode (Mode);
      Self.Set_Output_Speed (Speed);
      Self.Set_Pull_Mode (Pull);

      Self.Controller.Peripheral.GPIO_MODER.MODER (Self.Identifier) :=
        A0B.Peripherals.GPIO.Output;
   end Initialize_Output;

   ---------
   -- Set --
   ---------

   overriding procedure Set (Self : GPIO_Line; To : Boolean) is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

      Aux : A0B.Peripherals.GPIO.GPIO_BSRR_Register :=
        (BS => (others => False), BR => (others => False));

   begin
      if To then
         Aux.BS (Self.Identifier) := True;

      else
         Aux.BR (Self.Identifier) := True;
      end if;

      Self.Controller.Peripheral.GPIO_BSRR := Aux;
   end Set;

   ---------------------
   -- Set_Output_Mode --
   ---------------------

   procedure Set_Output_Mode
     (Self : aliased in out GPIO_Line'Class;
      To   : A0B.STM32.GPIO_Output_Mode)
   is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

   begin
      Self.Controller.Peripheral.GPIO_OTYPER.OTYPER (Self.Identifier) := To;
   end Set_Output_Mode;

   ----------------------
   -- Set_Output_Speed --
   ----------------------

   procedure Set_Output_Speed
     (Self : aliased in out GPIO_Line'Class;
      To   : A0B.STM32.GPIO_Output_Speed)
   is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

   begin
      Self.Controller.Peripheral.GPIO_OSPEEDR.OSPEEDR (Self.Identifier) := To;
   end Set_Output_Speed;

   -------------------
   -- Set_Pull_Mode --
   -------------------

   procedure Set_Pull_Mode
     (Self : aliased in out GPIO_Line'Class;
      To   : A0B.STM32.GPIO_Pull_Mode)
   is
      pragma Suppress (Range_Check);
      --  GPIO line identifier of the valid GPIO line is known to be in range
      --  of bit array.

   begin
      Self.Controller.Peripheral.GPIO_PUPDR.PUPDR (Self.Identifier) := To;
   end Set_Pull_Mode;

end A0B.STM32.Generic_GPIO;

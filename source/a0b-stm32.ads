--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

pragma Ada_2022;

private with A0B.Types;

package A0B.STM32
  with Preelaborate, No_Elaboration_Code_All
is

   type GPIO_Controller_Identifier is (A, B, C, D, E, F, G, H, I, J, K)
     with Size => 4;

   type GPIO_Line_Identifier is range 0 .. 15 with Size => 4;

   type GPIO_Output_Mode is (Push_Pull, Open_Drain) with Size => 1;

   type GPIO_Output_Speed is (Low, Medium, High, Very_High) with Size => 2;

   type GPIO_Pull_Mode is (No, Pull_Up, Pull_Down, Reserved_11) with Size => 2;

   type GPIO_Alternative_Function is private
     with Preelaborable_Initialization;

   type Function_Line_Descriptor (<>) is limited private
     with Preelaborable_Initialization;

private

   type GPIO_Alternative_Function is mod 2 ** 4;

   type Function_Line_Configuration is record
      Controller           : GPIO_Controller_Identifier;
      Line                 : GPIO_Line_Identifier;
      Alternative_Function : GPIO_Alternative_Function;
   end record with Pack;

   type Function_Line_Descriptor is
     array (A0B.Types.Unsigned_8 range <>) of Function_Line_Configuration;

end A0B.STM32;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:06:38 10/21/2019
-- Design Name:   
-- Module Name:   C:/Users/bruna/NeanderSD/NeanderSDtest.vhd
-- Project Name:  NeanderSD
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: NeanderSDmain
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY NeanderSDtest IS
END NeanderSDtest;
 
ARCHITECTURE behavior OF NeanderSDtest IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT NeanderSDmain
    PORT(
         clk : IN  std_logic;
         saida : OUT  std_logic_vector(7 downto 0);
         rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal saida : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: NeanderSDmain PORT MAP (
          clk => clk,
          saida => saida,
          rst => rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

  stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
		 wait for CLK_period*10;
		
		rst <= '1';
		
		wait for CLK_period*10;
		rst <= '0';
			wait for CLK_period*10;
      -- insert stimulus here 


      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:33:58 08/01/2014
-- Design Name:   
-- Module Name:   /home/mtrberzi/ym2608/operator_fb_tb.vhd
-- Project Name:  ym2608
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: operator_fb
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
USE ieee.numeric_std.ALL;
 
ENTITY operator_fb_tb IS
END operator_fb_tb;
 
ARCHITECTURE behavior OF operator_fb_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT operator_fb
    PORT(
			clk: in std_logic;
			rst: in std_logic;
			
			nxt: in std_logic;
			fb: unsigned(4 downto 0);
			phase: in unsigned(31 downto 0);
			envelope: in unsigned(15 downto 0);
			
			output: out signed(17 downto 0);
			valid: out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal nxt : std_logic := '0';
   signal fb : unsigned(4 downto 0) := (others => '0');
   signal phase : unsigned(31 downto 0) := (others => '0');
   signal envelope : unsigned(15 downto 0) := (others => '0');

 	--Outputs
   signal output : signed(17 downto 0);
   signal valid : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: operator_fb PORT MAP (
          clk => clk,
          rst => rst,
          nxt => nxt,
          fb => fb,
          phase => phase,
          envelope => envelope,
          output => output,
          valid => valid
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		rst <= '1';
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		rst <= '0';

      wait for clk_period*10;
		
      wait until falling_edge(clk);
		-- for an operator in initial conditions
		-- and fb=1, phase=0, envelope=361, we should see out=1
		fb <= to_unsigned(1, 5);
		phase <= to_unsigned(0, 32);
		envelope <= to_unsigned(361, 16);
		nxt <= '1';
		wait for clk_period;
		nxt <= '0';
		
		wait for clk_period * 3;
		-- now keeping everything else the same and setting phase=2932768,
		-- we should see out=12
		phase <= to_unsigned(2932768, 32);
		nxt <= '1';
		wait for clk_period;
		nxt <= '0';

      wait;
   end process;

END;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:12:14 08/01/2014 
-- Design Name: 
-- Module Name:    fm_channel - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fm_channel is Port ( 
	 clk : in  STD_LOGIC;
	 rst : in  STD_LOGIC;
	 
	 addr: in std_logic_vector(8 downto 0);
	 we: in std_logic;
	 data: in std_logic_vector(7 downto 0);
	 
	 nxt: in std_logic;
	 output: out signed(17 downto 0);
	 valid: out std_logic
);
end fm_channel;

architecture Behavioral of fm_channel is
	type buffer4_type is array(0 to 3) of signed(17 downto 0);
	constant buffer4_reset: buffer4_type := (
		0 => to_signed(0, 18),
		1 => to_signed(0, 18),
		2 => to_signed(0, 18),
		3 => to_signed(0, 18)
	);
	type algorithm_idx_type is array(0 to 5) of unsigned(1 downto 0);
	-- algorithm definitions and table
	
	-- in the original code, the indices correspond to table entries like this:
	-- idx 0 gets table entry 0
	-- idx 1 gets table entry 2
	-- idx 2 gets table entry 4
	-- idx 3 gets table entry 1
	-- idx 4 gets table entry 3
	-- idx 5 gets table entry 5
	constant algorithm0: algorithm_idx_type := (
		0 => to_unsigned(0, 2),
		3 => to_unsigned(1, 2),
		1 => to_unsigned(1, 2),
		4 => to_unsigned(2, 2),
		2 => to_unsigned(2, 2),
		5 => to_unsigned(3, 2)
	);
	constant algorithm1: algorithm_idx_type := (
		0 => to_unsigned(1, 2),
		3 => to_unsigned(0, 2),
		1 => to_unsigned(0, 2),
		4 => to_unsigned(1, 2),
		2 => to_unsigned(1, 2),
		5 => to_unsigned(2, 2)
	);
	constant algorithm2: algorithm_idx_type := (
		0 => to_unsigned(1, 2),
		3 => to_unsigned(1, 2),
		1 => to_unsigned(1, 2),
		4 => to_unsigned(0, 2),
		2 => to_unsigned(0, 2),
		5 => to_unsigned(2, 2)
	);
	constant algorithm3: algorithm_idx_type := (
		0 => to_unsigned(0, 2),
		3 => to_unsigned(1, 2),
		1 => to_unsigned(2, 2),
		4 => to_unsigned(1, 2),
		2 => to_unsigned(1, 2),
		5 => to_unsigned(2, 2)
	);
	constant algorithm4: algorithm_idx_type := (
		0 => to_unsigned(0, 2),
		3 => to_unsigned(1, 2),
		1 => to_unsigned(2, 2),
		4 => to_unsigned(2, 2),
		2 => to_unsigned(2, 2),
		5 => to_unsigned(1, 2)
	);
	constant algorithm5: algorithm_idx_type := (
		0 => to_unsigned(0, 2),
		3 => to_unsigned(1, 2),
		1 => to_unsigned(0, 2),
		4 => to_unsigned(1, 2),
		2 => to_unsigned(0, 2),
		5 => to_unsigned(1, 2)
	);
	constant algorithm6: algorithm_idx_type := (
		0 => to_unsigned(0, 2),
		3 => to_unsigned(1, 2),
		1 => to_unsigned(2, 2),
		4 => to_unsigned(1, 2),
		2 => to_unsigned(2, 2),
		5 => to_unsigned(1, 2)
	);
	constant algorithm7: algorithm_idx_type := (
		0 => to_unsigned(1, 2),
		3 => to_unsigned(0, 2),
		1 => to_unsigned(1, 2),
		4 => to_unsigned(0, 2),
		2 => to_unsigned(1, 2),
		5 => to_unsigned(0, 2)
	);
	-- notetab for bn
	type notetab_type is array(0 to 127) of unsigned(4 downto 0);
	constant notetab: notetab_type := (
		0 => to_unsigned(0, 5), 1 => to_unsigned(0, 5), 2 => to_unsigned(0, 5), 3 => to_unsigned(0, 5), 
		4 => to_unsigned(0, 5), 5 => to_unsigned(0, 5), 6 => to_unsigned(0, 5), 7 => to_unsigned(1, 5), 
		8 => to_unsigned(2, 5), 9 => to_unsigned(3, 5), 10 => to_unsigned(3, 5), 11 => to_unsigned(3, 5), 
		12 => to_unsigned(3, 5), 13 => to_unsigned(3, 5), 14 => to_unsigned(3, 5), 15 => to_unsigned(3, 5), 
		16 => to_unsigned(4, 5), 17 => to_unsigned(4, 5), 18 => to_unsigned(4, 5), 19 => to_unsigned(4, 5), 
		20 => to_unsigned(4, 5), 21 => to_unsigned(4, 5), 22 => to_unsigned(4, 5), 23 => to_unsigned(5, 5), 
		24 => to_unsigned(6, 5), 25 => to_unsigned(7, 5), 26 => to_unsigned(7, 5), 27 => to_unsigned(7, 5), 
		28 => to_unsigned(7, 5), 29 => to_unsigned(7, 5), 30 => to_unsigned(7, 5), 31 => to_unsigned(7, 5), 
		32 => to_unsigned(8, 5), 33 => to_unsigned(8, 5), 34 => to_unsigned(8, 5), 35 => to_unsigned(8, 5), 
		36 => to_unsigned(8, 5), 37 => to_unsigned(8, 5), 38 => to_unsigned(8, 5), 39 => to_unsigned(9, 5), 
		40 => to_unsigned(10, 5), 41 => to_unsigned(11, 5), 42 => to_unsigned(11, 5), 43 => to_unsigned(11, 5), 
		44 => to_unsigned(11, 5), 45 => to_unsigned(11, 5), 46 => to_unsigned(11, 5), 47 => to_unsigned(11, 5), 
		48 => to_unsigned(12, 5), 49 => to_unsigned(12, 5), 50 => to_unsigned(12, 5), 51 => to_unsigned(12, 5), 
		52 => to_unsigned(12, 5), 53 => to_unsigned(12, 5), 54 => to_unsigned(12, 5), 55 => to_unsigned(13, 5), 
		56 => to_unsigned(14, 5), 57 => to_unsigned(15, 5), 58 => to_unsigned(15, 5), 59 => to_unsigned(15, 5), 
		60 => to_unsigned(15, 5), 61 => to_unsigned(15, 5), 62 => to_unsigned(15, 5), 63 => to_unsigned(15, 5), 
		64 => to_unsigned(16, 5), 65 => to_unsigned(16, 5), 66 => to_unsigned(16, 5), 67 => to_unsigned(16, 5), 
		68 => to_unsigned(16, 5), 69 => to_unsigned(16, 5), 70 => to_unsigned(16, 5), 71 => to_unsigned(17, 5), 
		72 => to_unsigned(18, 5), 73 => to_unsigned(19, 5), 74 => to_unsigned(19, 5), 75 => to_unsigned(19, 5), 
		76 => to_unsigned(19, 5), 77 => to_unsigned(19, 5), 78 => to_unsigned(19, 5), 79 => to_unsigned(19, 5), 
		80 => to_unsigned(20, 5), 81 => to_unsigned(20, 5), 82 => to_unsigned(20, 5), 83 => to_unsigned(20, 5), 
		84 => to_unsigned(20, 5), 85 => to_unsigned(20, 5), 86 => to_unsigned(20, 5), 87 => to_unsigned(21, 5), 
		88 => to_unsigned(22, 5), 89 => to_unsigned(23, 5), 90 => to_unsigned(23, 5), 91 => to_unsigned(23, 5), 
		92 => to_unsigned(23, 5), 93 => to_unsigned(23, 5), 94 => to_unsigned(23, 5), 95 => to_unsigned(23, 5), 
		96 => to_unsigned(24, 5), 97 => to_unsigned(24, 5), 98 => to_unsigned(24, 5), 99 => to_unsigned(24, 5), 
		100 => to_unsigned(24, 5), 101 => to_unsigned(24, 5), 102 => to_unsigned(24, 5), 103 => to_unsigned(25, 5), 
		104 => to_unsigned(26, 5), 105 => to_unsigned(27, 5), 106 => to_unsigned(27, 5), 107 => to_unsigned(27, 5), 
		108 => to_unsigned(27, 5), 109 => to_unsigned(27, 5), 110 => to_unsigned(27, 5), 111 => to_unsigned(27, 5), 
		112 => to_unsigned(28, 5), 113 => to_unsigned(28, 5), 114 => to_unsigned(28, 5), 115 => to_unsigned(28, 5), 
		116 => to_unsigned(28, 5), 117 => to_unsigned(28, 5), 118 => to_unsigned(28, 5), 119 => to_unsigned(29, 5), 
		120 => to_unsigned(30, 5), 121 => to_unsigned(31, 5), 122 => to_unsigned(31, 5), 123 => to_unsigned(31, 5), 
		124 => to_unsigned(31, 5), 125 => to_unsigned(31, 5), 126 => to_unsigned(31, 5), 127 => to_unsigned(31, 5)
	);
	
	type fbtab_type is array(0 to 7) of unsigned(4 downto 0);
	constant fbtab: fbtab_type := (
		0 => to_unsigned(31, 5),
		1 => to_unsigned(7, 5),
		2 => to_unsigned(6, 5),
		3 => to_unsigned(5, 5),
		4 => to_unsigned(4, 5),
		5 => to_unsigned(3, 5),
		6 => to_unsigned(2, 5),
		7 => to_unsigned(1, 5)
	);
	
	type algorithm_table_type is array(0 to 7) of algorithm_idx_type;
	constant algorithm_table: algorithm_table_type := (
		0 => algorithm0,
		1 => algorithm1,
		2 => algorithm2,
		3 => algorithm3,
		4 => algorithm4,
		5 => algorithm5,
		6 => algorithm6,
		7 => algorithm7
	);
	
	type operator_reg_type is record
		dp: unsigned(17 downto 0); -- as a function of block/fnum
		bn: unsigned(4 downto 0); -- as a function of block/fnum
		detune: unsigned(7 downto 0);
		multiple: unsigned(3 downto 0);
		totalLevel: unsigned(6 downto 0);
		attackRate: unsigned(5 downto 0);
		decayRate: unsigned(5 downto 0);
		sustainRate: unsigned(5 downto 0);
		sustainLevel: unsigned(6 downto 0);
		releaseRate: unsigned(5 downto 0);
		keyscale: unsigned(1 downto 0);
		-- FIXME SSG-EG
		-- FIXME AMON, AMS, PMS
		-- FIXME L/R channel
	end record;
	
	constant operator_reg_reset: operator_reg_type := (
		dp => to_unsigned(0, 18),
		bn => to_unsigned(0, 5),
		detune => to_unsigned(0, 8),
		multiple => to_unsigned(0, 4),
		totalLevel => to_unsigned(127, 7),
		attackRate => to_unsigned(0, 6),
		decayRate => to_unsigned(0, 6),
		sustainRate => to_unsigned(0, 6),
		sustainLevel => to_unsigned(0, 7),
		releaseRate => to_unsigned(0, 6),
		keyscale => to_unsigned(0, 2)
	);
	
	type operator4_reg_type is array(0 to 3) of operator_reg_type;
	
	type channel_state_type is (state_idle, state_prepare, 
		state_op0, state_phase0, state_op1, state_phase1, state_op2, state_phase2, state_op3, state_phase3,
		state_accumulate, state_output);
	type channel_reg_type is record
		state: channel_state_type;
		-- (15 downto 8) is the fnum2 register, with block number;
		-- (7 downto 0) is the fnum1 register
		fnum: std_logic_vector(15 downto 0);
		opReg: operator4_reg_type; -- active operator parameters
		feedback: unsigned(4 downto 0);
		sampleBuffer: buffer4_type;
		algorithmIdx: algorithm_idx_type;
		opParam: operator4_reg_type; -- exposed register space for operator parameters
		paramChanged: std_logic_vector(3 downto 0); -- flags for each operator
		opUpdate: std_logic_vector(3 downto 0); -- strobed high when preparing channel to request EG/PG reload
		nxtOp: std_logic_vector(3 downto 0); -- strobed high to clock each operator
		nxtPhase: std_logic_vector(3 downto 0); --strobed high to clock each phase generator
		op1_input: signed(17 downto 0);
		op2_input: signed(17 downto 0);
		op3_input: signed(17 downto 0);
		output_tmp: signed(17 downto 0);
		output: signed(17 downto 0);
		valid: std_logic;
	end record;
	
	constant channel_reg_reset: channel_reg_type := (
		state => state_idle,
		fnum => X"0000",
		opReg => (others => operator_reg_reset),
		feedback => to_unsigned(1, 5), -- FIXME check this
		sampleBuffer => buffer4_reset,
		algorithmIdx => algorithm0,
		opParam => (others => operator_reg_reset),
		paramChanged => "0000",
		opUpdate => "0000",
		nxtOp => "0000",
		nxtPhase => "0000",
		op1_input => to_signed(0, 18),
		op2_input => to_signed(0, 18),
		op3_input => to_signed(0, 18),
		output_tmp => to_signed(0, 18),
		output => to_signed(0, 18),
		valid => '0'
	);
	
	signal reg: channel_reg_type := channel_reg_reset;
	signal ci_next: channel_reg_type;
	
	component operator_fb port (
		clk: in std_logic;
		rst: in std_logic;
		
		nxt: in std_logic;
		fb: unsigned(4 downto 0);
		phase: in unsigned(31 downto 0);
		envelope: in unsigned(15 downto 0);
		
		output: out signed(17 downto 0);
		valid: out std_logic
	); end component;
	
	component operator port (
		clk: in std_logic;
		rst: in std_logic;
		
		nxt: in std_logic;
		input: in signed(31 downto 0);
		phase: in unsigned(31 downto 0);
		envelope: in unsigned(15 downto 0);
		
		output: out signed(17 downto 0);
		valid: out std_logic
	); end component;
	
	component phase_generator Port ( 
		clk : in  STD_LOGIC;
		rst : in  STD_LOGIC;
		
		dp: in unsigned(17 downto 0);
		detune: in unsigned(7 downto 0);
		bn: in unsigned(4 downto 0);
		multiple: in unsigned(3 downto 0);
		
		update: in std_logic;
		nxt: in std_logic;
		phase: out unsigned(31 downto 0)
	); end component;
	signal op0_phase: unsigned(31 downto 0);
	signal op1_phase: unsigned(31 downto 0);
	signal op2_phase: unsigned(31 downto 0);
	signal op3_phase: unsigned(31 downto 0);
	
	-- output/valid from operators
	signal opValid: std_logic_vector(3 downto 0);
	signal op1_input: signed(31 downto 0);
	signal op2_input: signed(31 downto 0);
	signal op3_input: signed(31 downto 0);
	signal op0_output: signed(17 downto 0);
	signal op1_output: signed(17 downto 0);
	signal op2_output: signed(17 downto 0);
	signal op3_output: signed(17 downto 0);
begin

COMB: process(reg, rst, addr, we, data, nxt, opValid, op0_output, op1_output, op2_output, op3_output)
	variable ci: channel_reg_type;
	
	variable dp: unsigned(17 downto 0); -- as a function of block/fnum
	variable bn: unsigned(4 downto 0); -- as a function of block/fnum
	
	variable target_addr: std_logic_vector(7 downto 0);
	
	variable dp_shift_amt: integer;
begin
	ci := reg;
	-- self-clearing
	ci.opUpdate := "0000";
	ci.nxtOp := "0000";
	ci.nxtPhase := "0000";
	ci.valid := '0';
	
	target_addr := addr(7 downto 2) & "00";
	if(rst = '1') then
		ci := channel_reg_reset;
	else
		-- deal with writes to opParam
		if(we = '1') then
			case target_addr is
				-- DT/MULTI
				-- detune = (((data >> 4) & 0x07) * 0x20)
				--        = data(6 downto 4) <<5
				--        = data(6 downto 4) & "00000"
				-- multiple = data(3 downto 0)
				-- this forces a parameter update
				when X"30" => -- Detune/Multi, S1
					ci.opParam(0).detune := unsigned(data(6 downto 4) & "00000");
					ci.opParam(0).multiple := unsigned(data(3 downto 0));
					ci.paramChanged(0) := '1';
				when X"34" => -- Detune/Multi, S3
					ci.opParam(2).detune := unsigned(data(6 downto 4) & "00000");
					ci.opParam(2).multiple := unsigned(data(3 downto 0));
					ci.paramChanged(2) := '1';
				when X"38" => -- Detune/Multi, S2
					ci.opParam(1).detune := unsigned(data(6 downto 4) & "00000");
					ci.opParam(1).multiple := unsigned(data(3 downto 0));
					ci.paramChanged(1) := '1';
				when X"3C" => -- Detune/Multi, S4
					ci.opParam(3).detune := unsigned(data(6 downto 4) & "00000");
					ci.opParam(3).multiple := unsigned(data(3 downto 0));
					ci.paramChanged(3) := '1';
				when X"A0" => -- F-Number 1
					ci.fnum(7 downto 0) := data;
					-- recalculate dp/bn
					-- dp = (fnum & 2047) << ((fnum >> 11) & 7)
					dp_shift_amt := to_integer(unsigned(ci.fnum(13 downto 11)));
					dp := shift_left(unsigned("0000000" & ci.fnum(10 downto 0)), dp_shift_amt);
					-- bn = notetab[(fnum >> 7) & 127]
					bn := notetab(to_integer(unsigned(ci.fnum(13 downto 7))));
					-- assign this to every operator
					for I in 0 to 3 loop
						ci.opParam(I).dp := dp;
						ci.opParam(I).bn := bn;
						ci.paramChanged(I) := '1';
					end loop;
				when X"A4" => -- Block/F-Number 2
					ci.fnum(15 downto 8) := data;
				when X"B0" => -- feedback / algorithm
					ci.feedback := fbtab(to_integer(unsigned(data(5 downto 3))));
					ci.algorithmIdx := algorithm_table(to_integer(unsigned(data(2 downto 0))));
				when others => null;
			end case;
		end if;
		-- handle channel clocking
		case reg.state is
			when state_idle =>
				if(nxt = '1' and we = '0') then -- TODO verify whether removing (we = '0') will cause races/inconsistencies
					-- check paramChanged for each operator
					for I in 0 to 3 loop
						if(reg.paramChanged(I) = '1') then
							ci.opReg(I) := reg.opParam(I);
							ci.paramChanged(I) := '0';
							ci.opUpdate(I) := '1';
						end if;
					end loop;
					ci.sampleBuffer := buffer4_reset;
					ci.state := state_prepare;
				end if;
			when state_prepare =>
				-- TODO clock envelope generators in parallel
				ci.state := state_op0;
			when state_op0 =>
				ci.nxtOp(0) := '1';
				ci.state := state_phase0;
			when state_phase0 =>
				-- wait for operator 0 to be valid
				if(opValid(0) = '1') then
					-- store output 0 in buffer 0
					ci.sampleBuffer(0) := op0_output;
					ci.nxtPhase(0) := '1';
					ci.state := state_op1;
				end if;
			when state_op1 =>
				-- set input 1 to buffer[algorithm[0]]
				ci.op1_input := reg.sampleBuffer(to_integer(reg.algorithmIdx(0)));
				ci.nxtOp(1) := '1';
				ci.state := state_phase1;
			when state_phase1 =>
				-- wait for operator 1 to be valid
				if(opValid(1) = '1') then
					-- ACCUMULATE output from operator 1 into buffer[algorithm[3]]
					ci.sampleBuffer(to_integer(reg.algorithmIdx(3))) := reg.sampleBuffer(to_integer(reg.algorithmIdx(3))) + op1_output;
					ci.nxtPhase(1) := '1';
					ci.state := state_op2;
				end if;
			when state_op2 =>
				-- set input 2 to buffer[algorithm[1]]
				ci.op2_input := reg.sampleBuffer(to_integer(reg.algorithmIdx(1)));
				ci.nxtOp(2) := '1';
				ci.state := state_phase2;
			when state_phase2 =>
				-- wait for operator 2 to be valid
				if(opValid(2) = '1') then
					-- accumulate output from operator 2 into buffer[algorithm[4]]
					ci.sampleBuffer(to_integer(reg.algorithmIdx(4))) := reg.sampleBuffer(to_integer(reg.algorithmIdx(4))) + op2_output;
					ci.nxtPhase(2) := '1';
					ci.state := state_op3;
				end if;
			when state_op3 =>
				-- set input 3 to buffer[algorithm[2]]
				ci.op3_input := reg.sampleBuffer(to_integer(reg.algorithmIdx(2)));
				ci.nxtOp(3) := '1';
				ci.state := state_phase3;
			when state_phase3 =>
				-- wait for operator 3 to be valid
				if(opValid(3) = '1') then
					-- store output to temporary register
					ci.output_tmp := op3_output;
					ci.nxtPhase(3) := '1';
					ci.state := state_accumulate;
				end if;
			when state_accumulate =>
				-- accumulate buffer[algorithm[5]] into temporary register
				ci.output_tmp := reg.output_tmp + reg.sampleBuffer(to_integer(reg.algorithmIdx(5)));
				ci.state := state_output;
			when state_output =>
				ci.output := reg.output_tmp;
				ci.valid := '1';
				ci.state := state_idle;
			when others => null;
		end case;
	end if;
	ci_next <= ci;
end process COMB;

SEQ: process(clk, ci_next)
begin
	if(rising_edge(clk)) then
		reg <= ci_next;
	end if;
end process SEQ;

OP0: operator_fb port map (
	clk => clk,
	rst => rst,
	
	nxt => reg.nxtOp(0),
	fb => reg.feedback,
	phase => op0_phase,
	envelope => to_unsigned(361, 16), -- FIXME EG
	output => op0_output,
	valid => opValid(0)
);
op1_input <= resize(reg.op1_input, 32);
OP1: operator port map (
	clk => clk,
	rst => rst,
	nxt => reg.nxtOp(1),
	input => op1_input,
	phase => op1_phase,
	envelope => to_unsigned(1330, 16), -- FIXME EG
	output => op1_output,
	valid => opValid(1)
);
op2_input <= resize(reg.op2_input, 32);
OP2: operator port map (
	clk => clk,
	rst => rst,
	nxt => reg.nxtOp(2),
	input => op2_input,
	phase => op2_phase,
	envelope => to_unsigned(342, 16), -- FIXME EG
	output => op2_output,
	valid => opValid(2)
);
op3_input <= resize(reg.op3_input, 32);
OP3: operator port map (
	clk => clk,
	rst => rst,
	nxt => reg.nxtOp(3),
	input => op3_input,
	phase => op3_phase,
	envelope => to_unsigned(1330, 16), -- FIXME EG
	output => op3_output,
	valid => opValid(3)
);

PHASE0: phase_generator port map (
	clk => clk,
	rst => rst,
	dp => reg.opReg(0).dp,
	detune => reg.opReg(0).detune,
	bn => reg.opReg(0).bn,
	multiple => reg.opReg(0).multiple,
	update => reg.opUpdate(0),
	nxt => reg.nxtPhase(0),
	phase => op0_phase
);
PHASE1: phase_generator port map (
	clk => clk,
	rst => rst,
	dp => reg.opReg(1).dp,
	detune => reg.opReg(1).detune,
	bn => reg.opReg(1).bn,
	multiple => reg.opReg(1).multiple,
	update => reg.opUpdate(1),
	nxt => reg.nxtPhase(1),
	phase => op1_phase
);
PHASE2: phase_generator port map (
	clk => clk,
	rst => rst,
	dp => reg.opReg(2).dp,
	detune => reg.opReg(2).detune,
	bn => reg.opReg(2).bn,
	multiple => reg.opReg(2).multiple,
	update => reg.opUpdate(2),
	nxt => reg.nxtPhase(2),
	phase => op2_phase
);
PHASE3: phase_generator port map (
	clk => clk,
	rst => rst,
	dp => reg.opReg(3).dp,
	detune => reg.opReg(3).detune,
	bn => reg.opReg(3).bn,
	multiple => reg.opReg(3).multiple,
	update => reg.opUpdate(3),
	nxt => reg.nxtPhase(3),
	phase => op3_phase
);


-- outputs
output <= reg.output;
valid <= reg.valid;

end Behavioral;


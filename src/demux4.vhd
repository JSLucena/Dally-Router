----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2024 12:10:30 PM
-- Design Name: 
-- Module Name: demux4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use work.defs.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demux4 is
     GENERIC (
    PHASE_INIT_A : STD_LOGIC := '0';
    PHASE_INIT_B : STD_LOGIC := '0';
    PHASE_INIT_C : STD_LOGIC := '0';
    PHASE_INIT_D : STD_LOGIC := '0';
    PHASE_INIT_E : STD_LOGIC := '0'
  );  port(
    rst           : in  std_logic;
    -- Input port
    inA_req       : in  std_logic;
    inA_data      : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_ack       : out std_logic;
    -- Select port 
    inSel_req     : in  std_logic;
    inSel_ack     : out std_logic;
    selector      : in std_logic_vector(1 downto 0);
    -- Output channel 1
    outB_req      : out std_logic;
    outB_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outB_ack      : in  std_logic;
    -- Output channel 2
    outC_req      : out std_logic;
    outC_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outC_ack      : in  std_logic;
        -- Output channel 3
    outD_req      : out std_logic;
    outD_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outD_ack      : in  std_logic;
        -- Output channel 4
    outE_req      : out std_logic;
    outE_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outE_ack      : in  std_logic
    );
end demux4;

architecture Behavioral of demux4 is
  SIGNAL phase_a : STD_LOGIC;
  signal click, in_token, outB_bubble, outC_bubble,outD_bubble,outE_bubble : std_logic;
  signal b_selected, c_selected,d_selected,e_selected : std_logic;
  SIGNAL phase_b : STD_LOGIC;
  SIGNAL phase_c : STD_LOGIC;
  SIGNAL phase_d : STD_LOGIC;
  SIGNAL phase_e : STD_LOGIC;
  SIGNAL selectorx : std_logic_vector (3 downto 0); 
  signal data_reg : std_logic_vector(DATA_WIDTH-1 downto 0);
begin

   -- Control Path   
        inSel_ack <= phase_a;
        inA_ack <= phase_a;
        outB_req <= phase_b;
        outB_data <= data_reg;
        outC_req <= phase_c;
        outC_data <= data_reg;
        outD_req <= phase_d;
        outD_data <= data_reg;
        outE_req <= phase_e;
        outE_data <= data_reg;
      -- Selector trigger
      in_token <= (inSel_req and not(phase_a) and inA_req) or (not(inSel_req) and phase_a and not(inA_req)) after ANDOR3_DELAY + NOT1_DELAY;
    
      outB_bubble <= phase_b xnor outB_ack after XOR_DELAY + NOT1_DELAY;
      outC_bubble <= phase_c xnor outC_ack after XOR_DELAY + NOT1_DELAY;
      outD_bubble <= phase_d xnor outD_ack after XOR_DELAY + NOT1_DELAY;
      outE_bubble <= phase_e xnor outE_ack after XOR_DELAY + NOT1_DELAY;
      
      -- Select an option
      b_selected <= outB_bubble and in_token and  (selectorx(3)) after AND3_DELAY;
      c_selected <= outC_bubble and in_token and  (selectorx(2)) after AND3_DELAY;
      d_selected <= outD_bubble and in_token and  (selectorx(1)) after AND3_DELAY;
      e_selected <= outE_bubble and in_token and  (selectorx(0)) after AND3_DELAY;      
      
      click <= b_selected or c_selected or d_selected or e_selected  after OR2_DELAY;
    clock_regs : process(click, rst)
    begin
      if rst = '1' then
        phase_a <= PHASE_INIT_A;
        phase_b <= PHASE_INIT_B;
        phase_c <= PHASE_INIT_C;
        phase_d <= PHASE_INIT_D;
        phase_e <= PHASE_INIT_E;
        data_reg <= (others => '0');
      elsif rising_edge(click) then
        phase_a <= not phase_a after REG_CQ_DELAY;
        phase_b <= phase_b xor  (selectorx(3)) after REG_CQ_DELAY;
        phase_c <= phase_c xor (selectorx(2)) after REG_CQ_DELAY;
        phase_d <= phase_d xor  (selectorx(1)) after REG_CQ_DELAY;
        phase_e <= phase_e xor (selectorx(0)) after REG_CQ_DELAY;
        data_reg <= inA_data after REG_CQ_DELAY;
      end if;
    end process clock_regs;
     
   selectorx <= "0001" when selector = "00" else 
	 "0010" when selector = "01" else 
	 "0100" when selector = "10" else 
	 "1000" when selector = "11";
	     
end Behavioral;

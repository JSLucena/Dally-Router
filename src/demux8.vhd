----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2024 12:10:30 PM
-- Design Name: 
-- Module Name: demux8 - Behavioral
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

entity demux8 is
     GENERIC (
    PHASE_INIT_A : STD_LOGIC := '0';
    PHASE_INIT_B : STD_LOGIC := '0';
    PHASE_INIT_C : STD_LOGIC := '0';
    PHASE_INIT_D : STD_LOGIC := '0';
    PHASE_INIT_E : STD_LOGIC := '0';
    PHASE_INIT_F : STD_LOGIC := '0';
    PHASE_INIT_G : STD_LOGIC := '0';
    PHASE_INIT_H: STD_LOGIC := '0';
    PHASE_INIT_I : STD_LOGIC := '0'
  );
port(
    rst           : in  std_logic;
    -- Input port
    inA_req       : in  std_logic;
    inA_data      : in std_logic_vector(DATA_WIDTH-1 downto 0);
    inA_ack       : out std_logic;
    -- Select port 
    inSel_req     : in  std_logic;
    inSel_ack     : out std_logic;
    selector      : in std_logic_vector(2 downto 0);
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
    outE_ack      : in  std_logic;
    -- Output channel 5
    outF_req      : out std_logic;
    outF_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outF_ack      : in  std_logic;
    -- Output channel 6
    outG_req      : out std_logic;
    outG_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outG_ack      : in  std_logic;
    -- Output channel 7
    outH_req      : out std_logic;
    outH_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outH_ack      : in  std_logic;
    -- Output channel 8
    outI_req      : out std_logic;
    outI_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
    outI_ack      : in  std_logic
    );
end demux8;

architecture Behavioral of demux8 is
  SIGNAL phase_a : STD_LOGIC;
  signal click, in_token, outB_bubble, outC_bubble,outD_bubble,outE_bubble,outF_bubble,outG_bubble,outH_bubble,outI_bubble : std_logic;
  signal b_selected, c_selected,d_selected,e_selected,f_selected,g_selected,h_selected,i_selected : std_logic;
  SIGNAL phase_b : STD_LOGIC;
  SIGNAL phase_c : STD_LOGIC;
  SIGNAL phase_d : STD_LOGIC;
  SIGNAL phase_e : STD_LOGIC;
  SIGNAL phase_f : STD_LOGIC;
  SIGNAL phase_g : STD_LOGIC;
  SIGNAL phase_h : STD_LOGIC;
  SIGNAL phase_i : STD_LOGIC;
  SIGNAL selectorx : std_logic_vector (7 downto 0); 
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
        outF_req <= phase_f;
        outF_data <= data_reg;
        outG_req <= phase_g;
        outG_data <= data_reg;
        outH_req <= phase_h;
        outH_data <= data_reg;
        outI_req <= phase_i;
        outI_data <= data_reg;
      -- Selector trigger
      in_token <= (inSel_req and not(phase_a) and inA_req) or (not(inSel_req) and phase_a and not(inA_req)) after ANDOR3_DELAY + NOT1_DELAY;
    
      outB_bubble <= phase_b xnor outB_ack after XOR_DELAY + NOT1_DELAY;
      outC_bubble <= phase_c xnor outC_ack after XOR_DELAY + NOT1_DELAY;
      outD_bubble <= phase_d xnor outD_ack after XOR_DELAY + NOT1_DELAY;
      outE_bubble <= phase_e xnor outE_ack after XOR_DELAY + NOT1_DELAY;
      outF_bubble <= phase_f xnor outF_ack after XOR_DELAY + NOT1_DELAY;
      outG_bubble <= phase_g xnor outG_ack after XOR_DELAY + NOT1_DELAY;
      outH_bubble <= phase_h xnor outH_ack after XOR_DELAY + NOT1_DELAY;
      outI_bubble <= phase_i xnor outI_ack after XOR_DELAY + NOT1_DELAY;
      
      -- Select an option
      b_selected <= outB_bubble and in_token and  (selectorx(7)) after AND3_DELAY;
      c_selected <= outC_bubble and in_token and  (selectorx(6)) after AND3_DELAY;
      d_selected <= outD_bubble and in_token and  (selectorx(5)) after AND3_DELAY;
      e_selected <= outE_bubble and in_token and  (selectorx(4)) after AND3_DELAY;
      f_selected <= outF_bubble and in_token and  (selectorx(3)) after AND3_DELAY;
      g_selected <= outG_bubble and in_token and  (selectorx(2)) after AND3_DELAY;
      h_selected <= outH_bubble and in_token and  (selectorx(1)) after AND3_DELAY;
      i_selected <= outI_bubble and in_token and  (selectorx(0)) after AND3_DELAY;
      
      
      click <= b_selected or c_selected or d_selected or e_selected or f_selected or g_selected or h_selected or i_selected  after OR2_DELAY;
    clock_regs : process(click, rst)
    begin
      if rst = '1' then
        phase_a <= PHASE_INIT_A;
        phase_b <= PHASE_INIT_B;
        phase_c <= PHASE_INIT_C;
        phase_d <= PHASE_INIT_D;
        phase_e <= PHASE_INIT_E;
        phase_f <= PHASE_INIT_F;
        phase_g <= PHASE_INIT_G;
        phase_h <= PHASE_INIT_H;
        phase_i <= PHASE_INIT_I;
        data_reg <= (others => '0');
      elsif rising_edge(click) then
        phase_a <= not phase_a after REG_CQ_DELAY;
        phase_b <= phase_b xor  (selectorx(7)) after REG_CQ_DELAY;
        phase_c <= phase_c xor (selectorx(6)) after REG_CQ_DELAY;
        phase_d <= phase_d xor  (selectorx(5)) after REG_CQ_DELAY;
        phase_e <= phase_e xor (selectorx(4)) after REG_CQ_DELAY;
        phase_f <= phase_f xor  (selectorx(3)) after REG_CQ_DELAY;
        phase_g <= phase_g xor (selectorx(2)) after REG_CQ_DELAY;
        phase_h <= phase_h xor  (selectorx(1)) after REG_CQ_DELAY;
        phase_i <= phase_i xor (selectorx(0)) after REG_CQ_DELAY;
        data_reg <= inA_data after REG_CQ_DELAY;
      end if;
    end process clock_regs;
     
   selectorx <= "00000001" when selector = "000" else 
	 "00000010" when selector = "001" else 
	 "00000100" when selector = "010" else 
	 "00001000" when selector = "011" else 
	 "00010000" when selector = "100" else 
	 "00100000" when selector = "101" else 
	 "01000000" when selector = "110" else 
	 "10000000" when selector = "111";
	     
end Behavioral;

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
    component demux is
      port(
        rst           : in  std_logic;
        -- Input port
        inA_req       : in  std_logic;
        inA_data      : in std_logic_vector(DATA_WIDTH-1 downto 0);
        inA_ack       : out std_logic;
        -- Select port 
        inSel_req     : in  std_logic;
        inSel_ack     : out std_logic;
        selector      : in std_logic;
        -- Output channel 1
        outB_req      : out std_logic;
        outB_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        outB_ack      : in  std_logic;
        -- Output channel 2
        outC_req      : out std_logic;
        outC_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
        outC_ack      : in  std_logic
        );
    end component;
    signal D0_ack,D0S_ack,D1_req,D1S_req,D1_ack,D1S_ack,D2_req,D2S_req,D2_ack,D2S_ack : std_logic;
    signal D1_data,D2_data,D3_data,D4_data,D5_data,D6_data,B_data_out,C_data_out,D_data_out,E_data_out,F_data_out,G_data_out,H_data_out,I_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal D3_req,D3S_req,D3_ack,D3S_ack,D3S_data,D4_req,D4S_req,D4_ack,D4S_ack,D4S_data,D5_req,D5S_req,D5_ack,D5S_ack,D5S_data,D6_req,D6S_req,D6_ack,D6S_ack,D6S_data: std_logic;
    signal B_req_out,B_ack_out,C_req_out,C_ack_out,D_req_out,D_ack_out,E_req_out,E_ack_out,F_req_out,F_ack_out,G_req_out,G_ack_out,H_req_out,H_ack_out,I_req_out,I_ack_out :std_logic;
    signal crap,crap2,crap3:std_logic_vector(DATA_WIDTH-1 downto 0);
    signal D1S_data,D2S_data : std_logic_vector(1 downto 0);
begin
    inA_ack<= D0_ack;
    Demux_0 : demux port map(rst,inA_req ,inA_data ,D0_ack,inSel_req,D0S_ack,selector(1),D1_req,D1_data,D1_ack,D2_req,D2_data,D2_ack);
    Demux_1 : demux port map(rst=>rst,
                         inA_req => D1_req ,
                         inA_data => D1_data ,
                         inA_ack => D1_ack,
                         inSel_req => D1S_req,
                         inSel_ack => D1S_ack,
                         selector => D1S_data(1),
                         outB_req => D3_req,
                         outB_data => D3_data,
                         outB_ack => D3_ack,
                         outC_req => D4_req,
                         outC_data => D4_data,
                         outC_ack => D4_ack);
    Demux_2 : demux port map(rst=>rst,
                         inA_req => D2_req ,
                         inA_data => D2_data ,
                         inA_ack => D2_ack,
                         inSel_req => D2S_req,
                         inSel_ack => D2S_ack,
                         selector => D2S_data(1),
                         outB_req => D5_req,
                         outB_data => D5_data,
                         outB_ack => D5_ack,
                         outC_req => D6_req,
                         outC_data => D6_data,
                         outC_ack => D6_ack);
    Demux_3 : demux port map(rst=>rst,
                         inA_req => D3_req ,
                         inA_data => D3_data ,
                         inA_ack => D3_ack,
                         inSel_req => D3S_req,
                         inSel_ack => D3S_ack,
                         selector => D3S_data,
                         outB_req => B_req_out,
                         outB_data => B_data_out,
                         outB_ack => B_ack_out,
                         outC_req => C_req_out,
                         outC_data => C_data_out,
                         outC_ack => C_ack_out);    
    Demux_4 : demux port map(rst=>rst,
                         inA_req => D4_req ,
                         inA_data => D4_data ,
                         inA_ack => D4_ack,
                         inSel_req => D4S_req,
                         inSel_ack => D4S_ack,
                         selector => D4S_data,
                         outB_req => D_req_out,
                         outB_data => D_data_out,
                         outB_ack => D_ack_out,
                         outC_req => E_req_out,
                         outC_data => E_data_out,
                         outC_ack => E_ack_out);
    Demux_5 : demux port map(rst=>rst,
                         inA_req => D5_req ,
                         inA_data => D5_data ,
                         inA_ack => D5_ack,
                         inSel_req => D5S_req,
                         inSel_ack => D5S_ack,
                         selector => D5S_data,
                         outB_req => F_req_out,
                         outB_data => F_data_out,
                         outB_ack => F_ack_out,
                         outC_req => G_req_out,
                         outC_data => G_data_out,
                         outC_ack => G_ack_out);       
    Demux_6 : demux port map(rst=>rst,
                         inA_req => D5_req ,
                         inA_data => D5_data ,
                         inA_ack => D5_ack,
                         inSel_req => D5S_req,
                         inSel_ack => D5S_ack,
                         selector => D5S_data,
                         outB_req => H_req_out,
                         outB_data => H_data_out,
                         outB_ack => H_ack_out,
                         outC_req => I_req_out,
                         outC_data => I_data_out,
                         outC_ack => I_ack_out);                 
    Demux_S0 :demux port map(rst=>rst,
                         inA_req => inSel_req ,
                         inA_data => crap,
                         inA_ack => inSel_ack,
                         inSel_req => inSel_req,
                         inSel_ack => inSel_ack,
                         selector => selector(2),
                         outB_req => D1S_req,
                         outB_data => crap2,
                         outB_ack => D1S_ack,
                         outC_req => D2S_req,
                         outC_data => crap3,
                         outC_ack => D2S_ack);
                         
    Demux_S1 :demux port map(rst=>rst,
                         inA_req => inSel_req ,
                         inA_data => crap,
                         inA_ack => inSel_ack,
                         inSel_req => inSel_req,
                         inSel_ack => inSel_ack,
                         selector => selector(2),
                         outB_req => D1S_req,
                         outB_data => crap2,
                         outB_ack => D1S_ack,
                         outC_req => D2S_req,
                         outC_data => crap3,
                         outC_ack => D2S_ack);
 
    Demux_S2 :demux port map(rst=>rst,
                         inA_req => inSel_req ,
                         inA_data => crap,
                         inA_ack => inSel_ack,
                         inSel_req => inSel_req,
                         inSel_ack => inSel_ack,
                         selector => selector(2),
                         outB_req => D1S_req,
                         outB_data => crap2,
                         outB_ack => D1S_ack,
                         outC_req => D2S_req,
                         outC_data => crap3,
                         outC_ack => D2S_ack);                         
crap(0) <= selector(0);
D1S_data <= crap2(1 downto 0);
D2S_data <= crap3(1 downto 0);
end Behavioral;

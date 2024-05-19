----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2024 12:39:28 AM
-- Design Name: 
-- Module Name: tb_demux8 - Behavioral
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
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;
use work.defs.all;
entity demux8_tb is
end;

architecture bench of demux8_tb is

  component demux8
       GENERIC (
       
      PHASE_INIT_A : STD_LOGIC := '0';
      PHASE_INIT_B : STD_LOGIC := '0';
      PHASE_INIT_C : STD_LOGIC := '0';
      PHASE_INIT_D : STD_LOGIC := '0';
      PHASE_INIT_E : STD_LOGIC := '0';
      PHASE_INIT_F : STD_LOGIC := '0';
      PHASE_INIT_G : STD_LOGIC := '0';
      PHASE_INIT_H : STD_LOGIC := '0';
      PHASE_INIT_I : STD_LOGIC := '0'
    );
  port(
      rst           : in  std_logic;
      inA_req       : in  std_logic;
      inA_data      : in std_logic_vector(DATA_WIDTH-1 downto 0);
      inA_ack       : out std_logic;
      inSel_req     : in  std_logic;
      inSel_ack     : out std_logic;
      selector      : in std_logic_vector(2 downto 0);
      outB_req      : out std_logic;
      outB_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outB_ack      : in  std_logic;
      outC_req      : out std_logic;
      outC_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outC_ack      : in  std_logic;
      outD_req      : out std_logic;
      outD_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outD_ack      : in  std_logic;
      outE_req      : out std_logic;
      outE_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outE_ack      : in  std_logic;
      outF_req      : out std_logic;
      outF_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outF_ack      : in  std_logic;
      outG_req      : out std_logic;
      outG_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outG_ack      : in  std_logic;
      outH_req      : out std_logic;
      outH_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outH_ack      : in  std_logic;
      outI_req      : out std_logic;
      outI_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
      outI_ack      : in  std_logic
      );
  end component;

  signal rst: std_logic;
  signal inA_req: std_logic;
  signal inA_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal inA_ack: std_logic;
  signal inSel_req: std_logic;
  signal inSel_ack: std_logic;
  signal selector: std_logic_vector(2 downto 0);
  signal outB_req: std_logic;
  signal outB_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outB_ack: std_logic;
  signal outC_req: std_logic;
  signal outC_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outC_ack: std_logic;
  signal outD_req: std_logic;
  signal outD_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outD_ack: std_logic;
  signal outE_req: std_logic;
  signal outE_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outE_ack: std_logic;
  signal outF_req: std_logic;
  signal outF_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outF_ack: std_logic;
  signal outG_req: std_logic;
  signal outG_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outG_ack: std_logic;
  signal outH_req: std_logic;
  signal outH_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outH_ack: std_logic;
  signal outI_req: std_logic;
  signal outI_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal outI_ack: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: demux8 port map ( rst          => rst,
                            inA_req      => inA_req,
                            inA_data     => inA_data,
                            inA_ack      => inA_ack,
                            inSel_req    => inSel_req,
                            inSel_ack    => inSel_ack,
                            selector     => selector,
                            outB_req     => outB_req,
                            outB_data    => outB_data,
                            outB_ack     => outB_ack,
                            outC_req     => outC_req,
                            outC_data    => outC_data,
                            outC_ack     => outC_ack,
                            outD_req     => outD_req,
                            outD_data    => outD_data,
                            outD_ack     => outD_ack,
                            outE_req     => outE_req,
                            outE_data    => outE_data,
                            outE_ack     => outE_ack,
                            outF_req     => outF_req,
                            outF_data    => outF_data,
                            outF_ack     => outF_ack,
                            outG_req     => outG_req,
                            outG_data    => outG_data,
                            outG_ack     => outG_ack,
                            outH_req     => outH_req,
                            outH_data    => outH_data,
                            outH_ack     => outH_ack,
                            outI_req     => outI_req,
                            outI_data    => outI_data,
                            outI_ack     => outI_ack );

  stimulus: process
  begin
  
        -- Put initialisation code here
        outB_req <= 'L';
        outB_ack <= 'L';
        outC_req <= 'L';
        outC_ack <= 'L';
        outD_req <= 'L';
        outD_ack <= 'L';
        outE_req <= 'L';
        outE_ack <= 'L';
        outF_req <= 'L';
        outF_ack <= 'L';
        outG_req <= 'L';
        outG_ack <= 'L';
        outH_req <= 'L';
        outH_ack <= 'L';
        outI_req <= 'L';
        outI_ack <= 'L';
         inA_req <= 'L';
        inSel_req <= 'L';
        rst <= '1';
        inA_data <= X"fffffffff";
        selector <= "111";
        wait for 15ns;
        rst <= '0';
        wait for 15ns;
        inA_req <= '1';
        inSel_req <= '1';
    --    wait for 5ns;
    --     inA_req <= '0';
    --    inSel_req <= '0';
    --    wait for 50ns;
    --    inA_req <= '1';
    --    inSel_req <= '1';
        wait until outB_req'event;
        outB_ack <= outB_req after 5 ns;
        wait for 15ns;
        inA_data <= X"00fffffff";
        selector <= "110";
        wait for 15ns;
        inA_req <= not inA_req;
        inSel_req <= not inSel_req;
        wait until outC_req'event;
        outC_ack <= not outC_ack after 5 ns;
        inA_data <= X"fffffffff";
        selector <= "111";
        wait for 15ns;
        inA_req <= not inA_req;
        inSel_req <= not inSel_req;
        wait until outB_req'event;
        outB_ack <= outB_req after 5 ns;
        -- Put test bench stimulus code here

    wait;
  end process;


end;
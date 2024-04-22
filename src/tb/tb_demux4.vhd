----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2024 03:10:19 PM
-- Design Name: 
-- Module Name: tb_demux4 - Behavioral
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
entity demux4_tb is
end;

architecture bench of demux4_tb is

  component demux4
    port(
      rst           : in  std_logic;
      inA_req       : in  std_logic;
      inA_data      : in std_logic_vector(DATA_WIDTH-1 downto 0);
      inA_ack       : out std_logic;
      inSel_req     : in  std_logic;
      inSel_ack     : out std_logic;
      selector      : in std_logic_vector(1 downto 0);
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
      outE_ack      : in  std_logic
      );
  end component;

  signal rst: std_logic;
  signal inA_req: std_logic;
  signal inA_data: std_logic_vector(DATA_WIDTH-1 downto 0);
  signal inA_ack: std_logic;
  signal inSel_req: std_logic;
  signal inSel_ack: std_logic;
  signal selector: std_logic_vector(1 downto 0);
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
  signal outE_ack: std_logic ;

begin

  uut: demux4 port map ( rst       => rst,
                         inA_req   => inA_req,
                         inA_data  => inA_data,
                         inA_ack   => inA_ack,
                         inSel_req => inSel_req,
                         inSel_ack => inSel_ack,
                         selector  => selector,
                         outB_req  => outB_req,
                         outB_data => outB_data,
                         outB_ack  => outB_ack,
                         outC_req  => outC_req,
                         outC_data => outC_data,
                         outC_ack  => outC_ack,
                         outD_req  => outD_req,
                         outD_data => outD_data,
                         outD_ack  => outD_ack,
                         outE_req  => outE_req,
                         outE_data => outE_data,
                         outE_ack  => outE_ack );

  stimulus: process
  begin
  
    -- Put initialisation code here
    outB_req <= 'L';
    outB_ack <= 'L';
    rst <= '1';
    inA_data <= X"ffff";
    selector <= "11";
    wait for 10ns;
    rst <= '0';
    wait for 10ns;
    inA_req <= '1';
    inSel_req <= '1';
    wait for 5 ns;
      inA_req <= '0';
    inSel_req <= '0';
    wait for 5 ns;
    inA_req <= '1';
    inSel_req <= '1';
    wait until outB_req'event;
    outB_ack <= outB_req after 5 ns;
    wait until inA_ack'event;
    
    wait for 10 ns;
    selector <= "10";
    
    -- Put test bench stimulus code here

    wait;
    
    
  end process;


end;
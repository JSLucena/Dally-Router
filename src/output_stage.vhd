----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2024 11:23:58 AM
-- Design Name: 
-- Module Name: output_stage - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity output_stage is
    generic (
    DATAWIDTH  : natural := 32 );
    port(
    Reset : in STD_LOGIC;
    Ro_in : in std_logic_vector(3 downto 0);
    do_in : in std_logic_vector(DATAWIDTH -1 downto 0);
    ao_in : in std_logic_vector (3 downto 0);
    ro_out : out std_logic;
    do_out : out std_logic_vector(DATAWIDTH -1 downto 0)
    );
end output_stage;

architecture Behavioral of output_stage is

component  arbiter_4 is
      generic (
    DATA_WIDTH  : natural := 1);
    Port ( Reset : in STD_LOGIC;
           in_Reg : in STD_LOGIC_VECTOR (3 downto 0);
           in_Ack : out STD_LOGIC_VECTOR (3 downto 0);
           in_data_0 : in std_logic_vector(DATA_WIDTH-1 downto 0);
           in_data_1 : in std_logic_vector(DATA_WIDTH-1 downto 0);
           in_data_2 : in std_logic_vector(DATA_WIDTH-1 downto 0);
           in_data_3 : in std_logic_vector(DATA_WIDTH-1 downto 0);
           out_Reg : out STD_LOGIC;
           out_data : out std_logic_vector(DATA_WIDTH-1 downto 0);
           out_Ack : in STD_LOGIC);
end component;
signal ro_out_in :std_logic;
begin
--do_out <= do_in and ro_out_in;  -- neds to typecast it 
---arb : arbiter_4
end Behavioral;

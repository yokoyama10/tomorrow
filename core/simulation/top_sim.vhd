library ieee;
use ieee.std_logic_1164.all;

library tomorrow_1;
use tomorrow_1.top_pack.all;
use tomorrow_1.alu_pack.all;

--library unisim;
--use unisim.VComponents.all;

entity top_sim is
  port (
    MCLK1 : in  std_logic;
    RS_RX : in  std_logic;
    RS_TX : out std_logic;

    XE1    : out   std_logic;                       -- E1
    E2A    : out   std_logic;                       -- E2
    XE3    : out   std_logic;                       -- E3
    XGA    : out   std_logic;                       -- G
    XZCKE  : out   std_logic;                       -- CKE
    ADVA   : out   std_logic;                       -- ADV
    XLBO   : out   std_logic;                       -- LBO
    ZZA    : out   std_logic;                       -- ZZ
    XFT    : out   std_logic;                       -- FT
    XZBE   : out   std_logic_vector (0 to 3);       -- BA, BB
    ZCLKMA : out   std_logic_vector (0 to 1);       -- GIVE CLOCK
    XWA    : out   std_logic;                       -- WRITE ENABLE
    ZA     : out   std_logic_vector (19 downto 0);  -- ADDRESS
    ZD     : inout std_logic_vector (31 downto 0);  -- DATA
    ZDP    : inout std_logic_vector (3 downto 0)    -- PARITY
    );
end top_sim;


architecture RTL of top is

  signal clk : std_logic;

  signal PCWriteNC   : std_logic;
  signal PCWriteCond : std_logic;
  signal PCWrite     : std_logic;
  signal MemWrite    : std_logic;
  signal MemtoReg    : std_logic;
  signal IRWrite     : std_logic;
  signal RegDst      : std_logic_vector(1 downto 0);
  signal RegWrite    : std_logic;
  signal ALUSrcA     : std_logic;
  signal ALUSrcB     : std_logic_vector(1 downto 0);
  signal ALUOp       : ALU_CTRL;
  signal PCSource    : std_logic_vector(1 downto 0);

  signal IR         : std_logic_vector(31 downto 0);
  signal MDR        : std_logic_vector(31 downto 0);
  signal PC         : std_logic_vector(31 downto 0);
  signal FROMALU    : std_logic_vector(31 downto 0);
  signal DATA_WRITE : std_logic_vector(31 downto 0);


begin  -- RTL
--  ib : IBUFG port map (
--    i => MCLK1,
--    o => iclk);
--  bg : BUFG port map (
--    i => iclk,
--    o => clk);
  clk <= MCLK1;

  datapath_map : datapath
    port map (
      CLK         => clk,
      PCWriteNC   => PCWriteNC,
      PCWriteCond => PCWriteCond,
      PCWrite     => PCWrite,
      MemtoReg    => MemtoReg,
      RegDst      => RegDst,
      RegWrite    => RegWrite,
      ALUSrcA     => ALUSrcA,
      ALUSrcB     => ALUSrcB,
      ALUOp       => ALUOp,
      PCSource    => PCSource,

      IR         => IR,
      MDR        => MDR,
      PC_OUT     => PC,
      FROMALU    => FROMALU,
      DATA_WRITE => DATA_WRITE
      );

  controller_map : controller
    port map (
      CLK         => clk,
      OP          => IR(31 downto 26),
      PCWriteNC   => PCWriteNC,
      PCWriteCond => PCWriteCond,
      PCWrite     => PCWrite,
      MemWrite    => MemWrite,
      MemtoReg    => MemtoReg,
      IRWrite     => IRWrite,
      RegDst      => RegDst,
      RegWrite    => RegWrite,
      ALUSrcA     => ALUSrcA,
      ALUSrcB     => ALUSrcB,
      ALUOp       => ALUOp,
      PCSource    => PCSource);

  ram_map : ram
    generic map (
      BRAMBW => 15)
    port map (
      CLK        => clk,
      PC         => PC,
      FROMALU    => FROMALU,
      DATA_WRITE => DATA_WRITE,
      IR         => IR,
      MDR        => MDR,
      MemWrite   => MemWrite,
      IRWrite    => IRWrite,

      XE1    => XE1,
      E2A    => E2A,
      XE3    => XE3,
      XGA    => XGA,
      XZCKE  => XZCKE,
      ADVA   => ADVA,
      XLBO   => XLBO,
      ZZA    => ZZA,
      XFT    => XFT,
      XZBE   => XZBE,
      ZCLKMA => ZCLKMA,
      XWA    => XWA,
      ZA     => ZA,
      ZD     => ZD,
      ZDP    => ZDP);


end RTL;
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.std_logic_arith;

entity datapath_ahmes is
----------------------------------------------------------------------------------
	Port (  clk : in STD_LOGIC;
           reset: in STD_LOGIC;    
           
           cargaREM: in STD_LOGIC;
           cargaRDM : in STD_LOGIC;
           cargaAC : in STD_LOGIC;
           cargaRI : in STD_LOGIC;
           
           cargaN : in STD_LOGIC;
           cargaZ : in STD_LOGIC;
           cargaB : in STD_LOGIC;
           cargaV : in STD_LOGIC;
           cargaC : in STD_LOGIC;
           
           cargaPC : in STD_LOGIC;
           incPC : in STD_LOGIC;
           
           sel : in STD_LOGIC;
           selULA : in STD_LOGIC_VECTOR (3 downto 0);

           wr : in STD_LOGIC; --_VECTOR(0 DOWNTO 0);
           rd : in STD_LOGIC;
           
           out_RI : out STD_LOGIC_VECTOR (7 downto 0);
           out_PC : out STD_LOGIC_VECTOR (7 downto 0);
           out_AC : out STD_LOGIC_VECTOR (7 downto 0);
           
           flagN : out STD_LOGIC;
           flagZ : out STD_LOGIC;
           flagB : out STD_LOGIC;
           flagV : out STD_LOGIC;
           flagC : out STD_LOGIC);
end datapath_ahmes;
----------------------------------------------------------------------------------
architecture Behavioral of datapath_ahmes is
----------------------------------------------------------------------------------
--COMPONENT bram
--  PORT (
--    clka : IN STD_LOGIC;
--    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--  );
--END COMPONENT;

COMPONENT bram
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal reg_PC, reg_AC, reg_REM, reg_RDM, reg_RI: STD_LOGIC_VECTOR (7 downto 0);

signal ulaZ, regZ : std_logic;
signal ulaN, regN : std_logic;
signal ulaB, regB : std_logic;
signal ulaC, regC : std_logic;
signal ulaV, regV : std_logic;

signal out_ULA : STD_LOGIC_VECTOR (7 downto 0);
signal opAdd, opSub : std_logic_vector (8 downto 0);
signal outMuxREM, outMuxRDM : STD_LOGIC_VECTOR (7 downto 0);
signal dout : std_logic_vector (7 downto 0);
----------------------------------------------------------------------------------
begin
--	mem : bram
--	  PORT MAP (
--		 clka => clk,
--		 wea => wr,
--		 addra => reg_REM,
--		 dina => reg_RDM,
--		 douta => dout
--	  );
	mem: bram
	PORT MAP (
		a => reg_REM,
		d => reg_RDM,
		clk => clk,
		we => wr,
		spo => dout
	);
	----------------------------------------------------------------------------------
	regAC: process(clk, reset)
   begin
		if (reset = '1') then
			reg_AC <= (others => '0');
		elsif (rising_edge(clk)) then
			if (cargaAC = '1') then
				reg_AC <= out_ULA;
         end if;    
		end if;
	end process;
   out_AC <= reg_AC;
	----------------------------------------------------------------------------------
	regREM: process(clk,reset)
	begin
		if (reset = '1') then
			reg_REM <= (others => '0');
		elsif (rising_edge(clk)) then
			if (cargaREM = '1') then
				reg_REM <= outMuxREM;
			end if;
		end if;
    end process;
    ----------------------------------------------------------------------------------
    regRDM: process(clk, reset)
    begin
        if (reset = '1') then
            reg_RDM <= (others => '0');
        elsif (rising_edge(clk)) then
            if cargaRDM = '1' then
                reg_RDM <= outMuxRDM;
            end if;
        end if;
    end process;
    ----------------------------------------------------------------------------------
	regRI: process(clk, reset)
   begin
		if (reset = '1') then
			out_RI <= (others => '0');
		elsif (rising_edge(clk)) then
			if (cargaRI = '1') then
				out_RI <= reg_RDM;
			end if;
		end if;
   end process;
	----------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------
	regNegative: process(clk, reset)
	begin
		if (reset = '1') then
			regN <= '0';
		elsif (rising_edge(clk)) then
			if (cargaN = '1') then
				regN <= ulaN;
			end if;
		end if;
   end process;
	flagN <= regN;
	----------------------------------------------------------------------------------
	regZero: process(clk, reset)
	begin
		if (reset = '1') then
			regZ <= '1';
		elsif (rising_edge(clk)) then
			if (cargaZ = '1') then
				regZ <= ulaZ;
			end if;
		end if;
	end process;
	flagZ <= regZ;
	----------------------------------------------------------------------------------
	regBorrow: process(clk, reset)
   begin
		if (reset = '1') then
			regB <= '0';
		elsif (rising_edge(clk)) then
			if (cargaB = '1') then
				regB <= ulaB;
			end if;
		end if;
	end process;
	flagB <= regB;
	----------------------------------------------------------------------------------
	reg_oVerflow: process(clk, reset)
   begin
		if (reset = '1') then
			regV <= '0';
		elsif (rising_edge(clk)) then
			if (cargaV = '1') then
				regV <= ulaV;
			end if;
		end if;
	end process;
	flagV <= regV;
	----------------------------------------------------------------------------------
	regCarry: process(clk, reset)
   begin
		if (reset = '1') then
			regC <= '0';
		elsif (rising_edge(clk)) then
			if (cargaC = '1') then
				regC <= ulaC;
			end if;
		end if;
	end process;
	flagC <= regC;
	----------------------------------------------------------------------------------
	----------------------------------------------------------------------------------
   regPC: process(clk, reset)
	begin
		if (reset = '1') then
			reg_PC <= (others => '0');
		elsif (rising_edge(clk)) then
			if (cargaPC = '1') then
				reg_PC <= reg_RDM;
			elsif (incPC = '1') then
				reg_PC <= std_logic_vector(unsigned(reg_PC) + 1);
			end if; 
		end if;
   end process;
   out_PC <= reg_PC;
   ---------------------------------------------------------------------------------- 
	----------------------------------------------------------------------------------
	ULA: process(selULA, reg_AC, opSub, opAdd, out_ULA, reg_RDM)
     
   constant ulaNOT : std_logic_vector := "0000"; --not
   constant ulaAND : std_logic_vector := "0001"; --and
   constant ulaOR  : std_logic_vector := "0010"; --or
   constant ulaADD : std_logic_vector := "0011"; --add
   constant ulaLDA : std_logic_vector := "0100"; --lda
   constant ulaSUB : std_logic_vector := "0101"; --sub
   constant ulaSHR : std_logic_vector := "0110"; --shr
   constant ulaSHL : std_logic_vector := "0111"; --shl 
   constant ulaROR : std_logic_vector := "1000"; --ror
   constant ulaROL : std_logic_vector := "1001"; --rol
	 
	begin
   
		ulaV <= '0';        
		ulaC <= '0';
		ulaB <= '0';
		opSub <= (others => '0');
		opAdd <= (others => '0');
		out_ULA <= (others => '0');
			
		case selULA is 
			when ulaNOT => out_ULA <= not reg_AC;
					 
			when ulaAND => out_ULA <= reg_AC and reg_RDM;   
														 
			when ulaOR  => out_ULA <= reg_AC or reg_RDM;        
													
			when ulaADD => opADD   <= ("0"&reg_AC) + ("0" & reg_RDM);
								out_ULA <= opADD(7 downto 0);   
								ulaV <= (reg_AC(7) and reg_RDM(7) and (not out_ULA (7) )) or ((not reg_AC(7)) and (not reg_RDM(7)) and out_ULA (7) ); 
								ulaC <= opAdd(8); 
										 
			when ulaLDA => out_ULA <= reg_RDM;      
																	 
			when ulaSUB => opSub <= ("0"&reg_AC)-("0"&reg_RDM);                       
								out_ULA <= opSub(7 downto 0);
								ulaV <= (reg_AC(7) and not reg_RDM(7) and not out_ULA (7) ) or (not reg_AC(7) and reg_RDM(7) and out_ULA (7)); 
								ulaB <= opSub(8);
										 
			when ulaSHR => out_ULA <= std_logic_vector(shift_right(unsigned(reg_AC),1)); 
								ulaC <= reg_AC(0);
										 
			when ulaSHL => out_ULA <= std_logic_vector(shift_left(unsigned(reg_AC),1)); 
								ulaC <= reg_AC(7);
			  
			when ulaROR => out_ULA <= std_logic_vector(rotate_right(unsigned(reg_AC),1));
								ulaC <= reg_AC(0);

			when ulaROL => out_ULA <= std_logic_vector(rotate_left(unsigned(reg_AC),1)); 
								ulaC <= reg_AC(7);
										 
			when others => out_ULA <= (others => '0');
				
		end case;
		  
		ulaN <= out_ULA (7) ; 
		 
		if  out_ULA = "00000000" then 
			ulaZ <= '1';
		else 
			ulaZ <= '0'; 
		end if;
	end process;
	----------------------------------------------------------------------------------
   ----------------------------------------------------------------------------------            
   muxREM: process(sel, reg_PC, reg_RDM)
	begin
		case sel is 
			when '0' => outMuxREM <= reg_PC;
			when others => outMuxREM <= reg_RDM; --'1'
		end case;
	end process; 
   ----------------------------------------------------------------------------------            
   muxRDM: process(rd, reg_AC, dout)
	begin
		case rd is
			when '0' => outMuxRDM <= reg_AC;
			when others => outMuxRDM <= dout; --'1'
		end case;                  
	end process;
   ----------------------------------------------------------------------------------
	----------------------------------------------------------------------------------
end Behavioral;
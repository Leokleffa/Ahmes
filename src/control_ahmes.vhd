library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_ahmes is
    Port ( reset    : in    STD_LOGIC;
           clk      : in    STD_LOGIC;
           
           flagN    : in    STD_LOGIC;
           flagZ    : in    STD_LOGIC;
           flagB    : in    STD_LOGIC;
           flagV    : in    STD_LOGIC;
           flagC    : in    STD_LOGIC;
           
           reg_RI   : in    STD_LOGIC_VECTOR (7 downto 0);
           
           cargaREM : out   STD_LOGIC;
           cargaRDM : out   STD_LOGIC;
           cargaAC  : out   STD_LOGIC;
           cargaRI  : out   STD_LOGIC;
           
           cargaN   : out   STD_LOGIC;
           cargaZ   : out   STD_LOGIC;
           cargaB   : out   STD_LOGIC;
           cargaV   : out   STD_LOGIC;
           cargaC   : out   STD_LOGIC;
           
           cargaPC  : out   STD_LOGIC;
           incPC    : out   STD_LOGIC;
           
           sel      : out   STD_LOGIC;
           selULA   : out   STD_LOGIC_VECTOR (3 downto 0);

           wr       : out   STD_LOGIC; --_VECTOR(0 DOWNTO 0);
           rd       : out   STD_LOGIC);
end control_ahmes;

architecture Behavioral of control_ahmes is

	type T_STATE is (rst, t0, t1, t2, t3, t4, t5, t6, t7, hlt, 
   tw00, tw01, tw02, tw03, tw10, tw11, tw12, tw13, tw20, tw21, tw22, tw23); --wait time for reading the memory
   signal state, next_state : T_STATE ;
   signal out_decode : std_logic_vector(7 downto 0);

   begin
   
	sync_proc: process (clk, reset)
	begin
		if (reset = '1') then
			state <= rst;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;

	comb_proc: process(clk, reset, flagN, flagZ, flagV, flagB, flagC, state, reg_RI)
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
	
	constant codNOP : std_logic_vector(7 downto 0) := x"00";
	constant codSTA : std_logic_vector(7 downto 0) := x"10";
	constant codLDA : std_logic_vector(7 downto 0) := x"20";
	constant codADD : std_logic_vector(7 downto 0) := x"30"; 
	constant codOR  : std_logic_vector(7 downto 0) := x"40";
	constant codAND : std_logic_vector(7 downto 0) := x"50";
	constant codNOT : std_logic_vector(7 downto 0) := x"60";
	constant codSUB : std_logic_vector(7 downto 0) := x"70";
	constant codJMP : std_logic_vector(7 downto 0) := x"80";
	constant codJN  : std_logic_vector(7 downto 0) := x"90";
	constant codJP  : std_logic_vector(7 downto 0) := x"94";
	constant codJV  : std_logic_vector(7 downto 0) := x"98";
	constant codJNV : std_logic_vector(7 downto 0) := x"9C";
	constant codJZ  : std_logic_vector(7 downto 0) := x"A0"; 
	constant codJNZ : std_logic_vector(7 downto 0) := x"A4";
	constant codJC  : std_logic_vector(7 downto 0) := x"B0";
	constant codJNC : std_logic_vector(7 downto 0) := x"B4";
	constant codJB  : std_logic_vector(7 downto 0) := x"B8";
	constant codJNB : std_logic_vector(7 downto 0) := x"BC";
	constant codSHR : std_logic_vector(7 downto 0) := x"E0";
	constant codSHL : std_logic_vector(7 downto 0) := x"E1";
	constant codROR : std_logic_vector(7 downto 0) := x"E2";        
	constant codROL : std_logic_vector(7 downto 0) := x"E3";
	constant codHLT : std_logic_vector(7 downto 0) := x"F0";
         
	begin
		cargaREM <= '0';
		cargaRDM <= '0';
		cargaAC  <= '0';
		cargaRI  <= '0';
		
		cargaN   <= '0';
		cargaZ   <= '0';
		cargaB   <= '0';
		cargaV   <= '0';
		cargaC   <= '0';
		
		cargaPC  <= '0';
		incPC    <= '0';
		
		sel      <= '0';
		selULA   <= ulaLDA;
		wr       <= '0'; --"0";
		rd       <= '1';
            
		case state is
			when rst =>
				next_state <= t0;
				  
			when t0 =>
				sel <= '0';
				cargaREM <= '1';
				next_state <= tw00;    
			
			when tw00 => next_state <= tw01;
			when tw01 => next_state <= tw02;
			when tw02 => next_state <= tw03;
			when tw03 => next_state <= t1;
				  
			when t1 =>
						  rd <= '1';
						  incPC <= '1';
						  cargaRDM <= '1';
						  next_state <= t2;
											 
			when t2 =>                    
						  cargaRI <= '1';
						  next_state <= t3;
						  
			when t3 =>
				if (reg_RI = codNOT) then 
					selULA <= ulaNOT;
					cargaAC <= '1';
					cargaN <= '1';
					cargaZ <= '1';
					next_state <= t0;
				  
				elsif (reg_RI = codSHR or reg_RI = codSHL or reg_RI = codROR or reg_RI = codROL) then
					cargaAC <= '1';
					cargaN <= '1';
					cargaZ <= '1';
					cargaC <= '1';
							 
					case reg_RI is
						when codSHR => selULA <= ulaSHR;
						when codSHL => selULA <= ulaSHL;
						when codROR => selULA <= ulaROR;
						when others => selULA <= ulaROL;
					end case;
							 
					next_state <= t0;
							 
				elsif (reg_RI = codNOP) then
					next_state <= t0; 
						
				elsif (reg_RI = codHLT) then
					next_state <= hlt;
						
				else
					cargaREM <= '1';
					if((reg_RI = codJN and flagN = '0' ) or (reg_RI = codJP  and flagN = '1' ) or 
						(reg_RI = codJV and flagV = '0' ) or (reg_RI = codJNV and flagV = '1' ) or
						(reg_RI = codJZ and flagZ = '0' ) or (reg_RI = codJNZ and flagZ = '1' ) or 
						(reg_RI = codJC and flagC = '0' ) or (reg_RI = codJNC and flagC = '1' ) or 
						(reg_RI = codJB and flagB = '0' ) or (reg_RI = codJNB and flagB = '1' ) ) then
						
						incPC <= '1';   
						next_state <= t0;
							 
					else
						sel <= '0';
						cargaREM <= '1';
						next_state <= tw10;                    
					end if;    
						
				end if;
				  
			when tw10 => next_state <= tw11;
			when tw11 => next_state <= tw12;
			when tw12 => next_state <= tw13;
			when tw13 => next_state <= t4; 

			when t4 =>
				rd <= '1';
				cargaRDM <= '1';
				incPC <= '1';
				next_state <= t5;
				  
			when t5 =>                     
				case reg_RI is
					when codSTA | codLDA | codADD | codOR | codAND | codSUB => 
						sel <= '1';
						cargaREM <= '1';
						next_state <= tw20;
							 
					when others => 
						cargaPC <= '1';
						next_state <= t0;
							 
				end case;
						
			when tw20 => next_state <= tw21;
			when tw21 => next_state <= tw22;
			when tw22 => next_state <= tw23;
			when tw23 => next_state <= t6;
			 
			when t6 =>                
				if (reg_RI /= codSTA) then
					rd <= '1';
				else
					rd <= '0';
				end if;
				  
				cargaRDM <= '1';
				next_state <= t7;
				  
			when t7 =>                    
				if (reg_RI = codSTA) then 
					wr <= '1'; --"1";  
				else
					cargaAC <= '1';
					cargaN  <= '0';
					cargaZ  <= '0';
					cargaC  <= '0';
					cargaV  <= '0';
					cargaB  <= '0';  
					 
					case reg_RI is                    
						when codLDA =>
							selULA <= ulaLDA;
							cargaN <= '1';
							cargaZ <= '1';
									
							when codADD =>
								selULA <= ulaADD;
								cargaN <= '1';
								cargaZ <= '1';
								cargaC <= '1';
								cargaV <= '1';
									
							when codOR =>
								selULA <= ulaOR;
								cargaN <= '1';
								cargaZ <= '1';
									
							when codAND =>
								selULA <= ulaAND;
								cargaN <= '1';
									
							when codSUB =>
								selULA <= ulaSUB;
								cargaN <= '1';
								cargaZ <= '1';
								cargaV <= '1';
								cargaB <= '1';
									
							when others => 
								cargaAC <= '0';
					end case;
					 
				end if;
				  
				next_state <= t0;
				  
			when hlt => next_state <= hlt; 
						
		end case;
	end process;
end Behavioral;
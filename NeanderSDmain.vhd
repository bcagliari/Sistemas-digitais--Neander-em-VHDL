----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:16:14 10/20/2019 
-- Design Name: 
-- Module Name:    NeanderBrunaCC_main - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NeanderSDmain is
    Port ( clk : in  STD_LOGIC;
			  saida: out STD_LOGIC_VECTOR (7 downto 0);
           rst : in  STD_LOGIC);
			 
end NeanderSDmain;

architecture Behavioral of NeanderSDmain is

type T_STATE is (t0,t1,t2,t3,t4,t5,t6,t7,hlt_state);
signal estado, prox_estado : T_STATE;
type instructions is (NOP,STA,LDA,ADD,OROP,ANDOP,NOTOP,JMP,JN,JZ,HLT,MUL, SUB);
signal instruction : instructions;
signal contPC :  STD_LOGIC_VECTOR (7 downto 0);
signal incPC : STD_LOGIC;
signal cargaPC : STD_LOGIC;
signal spc : STD_LOGIC_VECTOR (7 downto 0);
signal smem: STD_LOGIC_VECTOR (7 downto 0);
signal mem_in: STD_LOGIC_VECTOR (7 downto 0);
signal smux: STD_LOGIC_VECTOR (7 downto 0);
signal selMUX : STD_LOGIC;
signal reg_rem: STD_LOGIC_VECTOR (7 downto 0);
signal srem: STD_LOGIC_VECTOR (7 downto 0);
signal cargaREM : STD_LOGIC;
signal srdm : STD_LOGIC_VECTOR (7 downto 0);
signal cargaAC : STD_LOGIC;
signal sac: STD_LOGIC_VECTOR (7 downto 0);
signal reg_ac: STD_LOGIC_VECTOR (7 downto 0);
signal sula : STD_LOGIC_VECTOR (7 downto 0);
signal selULA: STD_LOGIC_VECTOR (2 downto 0);
signal reg_ula: STD_LOGIC_VECTOR (7 downto 0);
signal x: STD_LOGIC_VECTOR (7 downto 0);
signal y: STD_LOGIC_VECTOR (7 downto 0);
signal cargaRI: STD_LOGIC;
signal reg_ri: STD_LOGIC_VECTOR (7 downto 0);
signal sri: STD_LOGIC_VECTOR (7 downto 0);
signal reg_rdm: STD_LOGIC_VECTOR (7 downto 0);
signal cargaRDM: STD_LOGIC;
signal cargaNZ: STD_LOGIC;
signal snz: STD_LOGIC_VECTOR (1 downto 0);
signal reg_nz: STD_LOGIC_VECTOR (1 downto 0);
signal write_enable :  STD_LOGIC_VECTOR(0 DOWNTO 0);


COMPONENT NeanderSDm
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;



begin


memoria : NeanderSDm
  PORT MAP (
    clka => clk,
    wea => write_enable,
    addra => srem,
    dina => mem_in,
    douta => smem
  );



	
--pc

process(clk, rst)
begin
	if( rst = '1') then
		contPC <= "00000000";
	elsif(clk'event and clk = '1') then
		if(cargaPC = '1') then
			--contPC <= srdm;
			contPC <= smem;
		else
			if(incPC = '1') then
				contPC <= contPC + 1;
				else
					contPC <= contPC;
			end if;
		end if;
	end if;
end process;
spc <= contPC;

--mux2x1

process(selMUX, clk)
begin
	case selMUX is
		when '0' =>
			smux <= spc;
		when '1' => 
			--smux <= srdm;
				smux <= smem;
		when others =>
			smux <= "00000000";
	end case;
end process;

--rem

process (clk, rst)
begin
	if (rst = '1') then
		reg_rem <= "00000000";
	elsif (clk'event and clk = '1') then
		if (cargaREM = '1') then
			reg_rem <= smux;
		else
			reg_rem <= reg_rem;
		end if;
	end if;
end process;
srem <= reg_rem;


--rdm

--process(clk, rst)
--begin
--	if (rst = '1') then
--		reg_rdm <= "00000000";
--	elsif (clk'event and clk = '1') then
--		if (cargaRDM = '1') then
--			reg_rdm <= smem;
--		else
--			reg_rdm <= reg_rdm;
--		end if;
--	end if;
--end process;
--srdm <= reg_rdm;
	

--ula

x <= sac;

process(selULA, y)
begin
--y <= srdm;
y <= smem;
	case selULA is
		when "000" =>
			reg_ula <= x + y;
		when "001" =>
			reg_ula <= x and y;
		when "010" =>
			reg_ula <= x or y;
		when "011" =>
			reg_ula <= not x;
		when "100" =>
			reg_ula <= y;
		when "101" =>
			reg_ula <= x - y;
		when "110" =>
			reg_ula <= x(3 downto 0) * y(3 downto 0);
		when others =>
			reg_ula <= "00000000";
	end case;
end process;
sula <= reg_ula;

--ac

process(clk, rst) 
begin
	if (rst = '1') then 
		reg_ac <= "00000000";
	elsif(clk'event and clk = '1') then
		if(cargaAC = '1') then
			reg_ac <= sula;
		else
			reg_ac <= reg_ac;
		end if;	
	end if;		
end process;			
sac <= reg_ac;
			

--ri

process(clk,rst)
begin
	if (rst = '1') then
		reg_ri <= "00000000";
	elsif (clk'event and clk = '1') then
		if(cargaRI = '1') then
			--reg_ri <= srdm;
			reg_ri <= smem;
		else
			reg_ri <= reg_ri;
		end if;
	end if;
end process;
sri <= reg_ri;

--negativo ou zero

process(clk, rst)
begin
	if (rst = '1') then 
		reg_nz <= "00";
	elsif(clk'event and clk = '1') then
		if(cargaNZ = '1') then
			if( sac = "00000000") then
				reg_nz(0) <= '1';
			else
				reg_nz(0) <= '0';
			end if;
				reg_nz(1) <= sac(7);
		else
			reg_nz <= reg_nz;
		end if;
	end if;
end process;
snz <= reg_nz;

--decodificador

process(sri)
begin
	case sri (7 downto 4) is
		when "0000"  => instruction <= NOP;
		when "0001"  => instruction <= STA;
		when "0010"  => instruction <= LDA;
		when "0011"  => instruction <= ADD;
		when "0100"  => instruction <= OROP;
		when "0101"  => instruction <= ANDOP;
		when "0110"  => instruction <= NOTOP;
		when "1000"  => instruction <= JMP;
		when "1001"  => instruction <= JN;
		when "1010"  => instruction <= JZ;
		when "1011"  => instruction <= SUB;
		when "1100"  => instruction <= MUL;
		when others  => instruction <= HLT;
		 
	end case;
end process;

-- Maquina de Estados

Process(clk, rst)
Begin
If rst='1' then
 estado <= t0;
Elsif (clk'event and clk='1') then
 estado <= prox_estado;
End if;
End process;
Process(cargaAC,cargaNZ,selMUX,cargaPC,incPC,write_enable,cargaREM,estado,instruction)

Begin
case estado is
when t0 =>
	cargaRI <= '0' ;  
	cargaAC      <= '0';   
	cargaNZ      <= '0';  
	cargaPC      <= '0';   
	incPC <= '0';   
	write_enable <= "0";   
	selMUX          <= '0';
	cargaREM     <= '1';
	prox_estado <= t1;

when t1 =>
	cargaREM <= '0' ;       
	mem_in<=srem;	
	incPC <= '1';
	prox_estado <= t2;

when t2 =>
	incPC <= '0';   
	cargaRI <= '1';
	prox_estado <= t3;

when t3 => 
	incPC <= '0'; 
	cargaRI <= '0' ;        
	if (instruction=STA or instruction=LDA or instruction=MUL or  instruction=SUB or instruction=ADD or instruction=OROP or instruction=ANDOP or instruction=JMP) then
		selMUX <= '0';
		cargaREM <= '1';
		prox_estado <= t4;
	elsif (instruction=NOTOP) then
		selULA <= "011";----------------------------
		cargaAC <= '1';
		cargaNZ <= '1';
		prox_estado <= t0;

	elsif (instruction=JN and snz(1)='0') then
		incPC <= '1';
		prox_estado <= t0;
	elsif (instruction=JN and snz(1)='1') then
		selMUX <= '0';
		cargaREM <= '1';
		prox_estado <= t4;
	elsif (instruction=JZ and snz(0)='1') then
		selMUX <= '0';
		cargaREM <= '1';
		prox_estado <= t4;
	elsif (instruction=JZ and snz(0)='0') then
		incPC <= '1';
		prox_estado <= t0;
	elsif (instruction=NOP) then
		prox_estado <= t0;
	elsif (instruction=HLT) then
		incPC <= '0';
		prox_estado <= hlt_state;
	else
		prox_estado <= t4;
	end if;
when t4 => 
		selMUX <= '0';  
		incPC <= '0';
		cargaAC  <= '0';        
		cargaNZ  <= '0';       
		cargaREM <= '0';        
		if(instruction=STA or instruction=LDA or instruction=MUL or instruction=SUB or instruction=ADD or instruction=OROP or instruction=ANDOP) then
			mem_in<=srem;
			incPC <= '1';
			prox_estado <= t5;
			
		elsif(instruction=JMP) then
			mem_in<=srem;
			prox_estado <= t5;
			
		elsif(instruction=JN and snz(1)='1') then
			mem_in<=srem;
			prox_estado <= t5;
			
		elsif(instruction=JZ and snz(0)='1') then
			mem_in<=srem;
			prox_estado <= t5;
			
		else 
			prox_estado <= t5;
		
		end if;
when t5 =>
	incPC <= '0' ; 		   
		if(instruction=STA or instruction=LDA or instruction=SUB or instruction=ADD or instruction=MUL or instruction=OROP or instruction=ANDOP) then
			selMUX <= '1';
			cargaREM <= '1';
			prox_estado <= t6;
		elsif(instruction=JMP ) then
			cargaPC <= '1';
			prox_estado <= t0;
		elsif(instruction=JN and snz(1)='1') then
			cargaPC <= '1';
			prox_estado <= t0;
		elsif(instruction=JZ and snz(0)='1') then
			cargaPC <= '1';
			prox_estado <= t0;
		else
			prox_estado <= t6;
		end if;
when t6 =>
	incPC <= '0'; 
	selMUX <= '0';       
	cargaREM <= '0';  
	cargaPC <= '0';  
		
		if(instruction=LDA or instruction=ADD or instruction=SUB or  instruction=MUL or instruction=OROP or instruction=ANDOP) then
			mem_in<=srem;	
			prox_estado <= t7;
		else
			prox_estado <= t7;
		end if;
when t7 =>
		incPC <= '0'; 
		if(instruction=STA) then
			mem_in<=sac;
			write_enable <= "1";
			prox_estado <= t0;
			
		elsif(instruction=LDA) then
			selULA <= "100";
			cargaAC <= '1';
			cargaNZ <= '1';
			prox_estado <= t0;
			
		elsif(instruction=MUL) then
			selULA <= "110";
			cargaAC <= '1';
			cargaNZ <= '1';
			prox_estado <= t0;
			
		elsif(instruction=ADD) then
			selULA <= "000";
			cargaAC <= '1';
			cargaNZ <= '1';
			prox_estado <= t0;
			
		elsif(instruction=SUB) then
			selULA <= "101";
			cargaAC <= '1';
			cargaNZ <= '1';
			prox_estado <= t0;
			
		elsif(instruction=OROP) then
			selULA <= "010";
			cargaAC <= '1';
			cargaNZ <= '1';
			prox_estado <= t0;
		elsif(instruction=ANDOP) then
			selULA <= "001";
			cargaAC <= '1';
			cargaNZ <= '1';
			prox_estado <= t0;
		else
			prox_estado <= t0;
		end if;
	
		
when hlt_state =>		
	incPC <= '0';
		prox_estado <= hlt_state;
		
end case;
End process; 

saida <= sac;
y <=smem;

			
end Behavioral;


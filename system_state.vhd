library IEEE;

use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity system_state is 

	port ( clk			: in std_logic; 

	 	ireset 			: in std_logic; 

		data_valid 		: in std_logic; 

		key_press 		: in std_logic_vector(4 downto 0);



		direction 		: out std_logic;  

		halt 			: out std_logic;  

		PR_pulse 		: out std_logic; 

		OP_mode 		: out std_logic; 

		init			: out std_logic; 

		Add_Data 		: out std_logic_vector( downto )





architecture behavioral of system_state is 

	type state_type is (init, OP_F_Halt, OP_R_Halt, OP_F, OP_R, PR_F_Data, PR_F_Add, PR_R_Data, PR_R_Add);

	signal state				: state_type; 

	signal direction_s 			: std_logic; 

	signal halt_s 				: std_logic; 

	signal PR_pulse_s 			: std_logic; 					 - - signals just in case 

	signal OP_mode_s 			: std_logic; 

	signal init_s 				: std_logic; 

	signal Add_Data_s 			: std_logic_vector; 

	signal count 				: unsigned(27 downto 0) := X”000000F”;







clk_enabler:

process(clk, ireset)

begin

    	if (ireset = '1') then

       	count <= 0;

        	clk_en <= '0';

    	elsif rising_edge(clk) then

	count <= count + 1;

        	if (count = 25000) then		— 1KHz clock divider (60ms ?)

        	clk_en <= '1';

        	count <= 0;

        	else

        	clk_en <= '0';

        end if;

    end if;

end process;



clk_enabler:

process(clk, ireset)

begin

    	if (ireset = '1') then

       	count <= 0;

        	clk_en <= '0';

    	elsif rising_edge(clk) then

	count <= count + 1;

        	if (count = 25000000) then		— 1Hz clock divider (1 sec ?)

        	clk_en <= '1';

        	count <= 0;

        	else

        	clk_en <= '0';

        end if;

    end if;

end process;









process(clk)

begin

	if ireset = ‘0’ then 

	state <= init; 



	if( clk’event and clk = ‘1’) then 

case state_type is 

	when init => 

		state_type <= OP_F_Halt; 			  		— 	RW = 0

		halt <= ‘0’;



	when OP_F_Halt => 

		if data_valid** 

		if key_press = ‘10001’ then			— H pressed 

		state_type <= OP_F;

		halt <= ‘0’;



		elseif key_press = ’10000’ then		-- L pressed 			RW = 1

		state_type <= OP_R_Halt;

		halt <= ‘1’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= PR_F_Data;	

		halt <= ‘0’;

		end if; 



	when OP_F => 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= OP_F_Halt;

		halt <= ‘1’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 1

		state_type <= OP_R;

		halt <= ‘0’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= PR_F_Data;	

		halt <= ‘0’;

		end if; 



	when OP_R_Halt => 

		if data_valid** 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= OP_R;

		halt <= ‘0’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 1

		state_type <= OP_F_Halt;

		halt <= ‘1’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= PR_R_Data;	

		halt <= ‘0’;

		end if; 



	when OP_R => 

		if data_valid** 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= OP_R_Halt;

		halt <= ‘1’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 1

		state_type <= OP_F;

		halt <= ‘0’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= PR_R_Data;	

		halt <= ‘0’;

		end if; 



	when PR_F_Data =>

		if data_valid** 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= PR_F_Add;

		halt <= ‘0’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 0

		state_type <= PR_F_Data;

		halt <= ‘0’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= OP_F_Halt;	

		halt <= ‘1’;

		end if; 





	when PR_F_Add => 

		if data_valid** 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= PR_F_Data;

		halt <= ‘0’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 0

		state_type <= PR_F_Add;

		halt <= ‘0’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= OP_F_Halt;	

		halt <= ‘1’;

		end if; 



	when  PR_R_Data =>

		if data_valid** 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= PR_R_Add;

		halt <= ‘0’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 0 

		state_type <= PR_R_Data;

		halt <= ‘0’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= OP_R_Halt;	

		halt <= ‘1’;

		end if; 



	when PR_R_Add => 

		if data_valid** 

		if key_press = ‘10001’ then			-- H pressed 

		state_type <= PR_R_Data;

		halt <= ‘0’;



		elseif key_press = ’10000’ then		-- L pressed  			RW = 0 

		state_type <= PR_R_Add;

		halt <= ‘0’;



		elseif key_press = ‘10010’ then		-- SH pressed 

		state_type <= OP_R_Halt;	

		halt <= ‘1’;

		end if; 

end if;

end process; 

end behavioral; 
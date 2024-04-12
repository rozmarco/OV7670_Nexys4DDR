----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Generate analog 640x480 VGA, double-doublescanned from 19200 bytes of RAM
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_vga is
    port ( 
        clk25       : in  STD_LOGIC;
        vga_red     : out STD_LOGIC_VECTOR(3 downto 0);
        vga_green   : out STD_LOGIC_VECTOR(3 downto 0);
        vga_blue    : out STD_LOGIC_VECTOR(3 downto 0);
        vga_hsync   : out STD_LOGIC;
        vga_vsync   : out STD_LOGIC;
        frame_addr  : out STD_LOGIC_VECTOR(17 downto 0);
        frame_pixel : in  STD_LOGIC_VECTOR(11 downto 0);
        located	    : in  STD_LOGIC; 
        amplitude   : in  STD_LOGIC_VECTOR(6 downto 0)
    );
end ov7670_vga;

architecture Behavioral of ov7670_vga is
   -- Timing constants
   constant hRez       : natural := 640;
   constant hStartSync : natural := 640+16;
   constant hEndSync   : natural := 640+16+96;
   constant hMaxCount  : natural := 800;
   
   constant vRez       : natural := 480;
   constant vStartSync : natural := 480+10;
   constant vEndSync   : natural := 480+10+2;
   constant vMaxCount  : natural := 480+10+2+33;
   
   constant v_start    : natural := 50;
   constant h_start    : natural := 525;
   constant e_height   : natural := 21;
   constant e_width    : natural := 2+11;
   
   constant amp_v_start : natural:= 30;
   constant amp_h_start : natural := 525;
   
   constant amp_height : natural := 11;
   constant amp_width  : natural := 2+5;
   
   
   
   constant hsync_active : std_logic := '0';
   constant vsync_active : std_logic := '0';

   signal hCounter : unsigned( 9 downto 0) := (others => '0');
   signal vCounter : unsigned( 9 downto 0) := (others => '0');
   signal address  : unsigned(18 downto 0) := (others => '0');
   signal blank    : std_logic := '1';

begin
   frame_addr <= std_logic_vector(address(18 downto 1));
   
   process(clk25)
   begin
      if rising_edge(clk25) then
         -- Count the lines and rows      
         if hCounter = hMaxCount-1 then
            hCounter <= (others => '0');
            if vCounter = vMaxCount-1 then
               vCounter <= (others => '0');
            else
               vCounter <= vCounter+1;
            end if;
         else
            hCounter <= hCounter+1;
         end if;

         if blank = '0' then
           vga_red   <= frame_pixel(11 downto 8);
           vga_green <= frame_pixel( 7 downto 4);
           vga_blue  <= frame_pixel( 3 downto 0);
           
           
           if (hCounter >= 540) then
                 vga_red <= "0000";
		 vga_green <= "0000";
		 vga_blue <= "0000";
           end if;
           
           
           
           -- amplitude box
           if (hCounter >=h_start -2 and hCounter <= h_start-2 +77+2 and vCounter >= amp_v_start -2 and vCounter <=amp_v_start -2+4+11) then
		       vga_red <= "1111";
		       vga_green <= "1111";
		       vga_blue <= "1111";
           end if;
           
           -- A
	   if (hCounter >= amp_h_start and hCounter <= amp_h_start +4 and vCounter = amp_v_start) or -- Top curve of S
	      (vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height and hCounter = amp_h_start) or  -- Middle line of S
	      (vCounter = amp_v_start+5 and hCounter >= amp_h_start and hCounter <= amp_h_start+4) or -- Bottom curve of S
	      (vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height and hCounter = amp_h_start+4) then -- Bottom curve of S
		vga_red   <= (others => '0');
		vga_green <= (others => '0');
		vga_blue  <= "1111"; -- Set the pixel to blue 
	   end if;
	   
	   
	   -- M
	   if (vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height and hCounter = amp_h_start+amp_width) or  -- Middle line of S
	      (vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height and hCounter = amp_h_start+4+amp_width) or  -- Middle line of S
	      (vCounter >= amp_v_start+2 and vCounter <= amp_v_start+3 and hCounter = amp_h_start+1+amp_width) or  -- Middle line of S
	      (vCounter >= amp_v_start+4 and vCounter <= amp_v_start+5 and hCounter = amp_h_start+2+amp_width) or  -- Middle line of S
	      (vCounter >= amp_v_start+2 and vCounter <= amp_v_start+3 and hCounter = amp_h_start+3+amp_width)then -- Bottom curve of S
		vga_red   <= (others => '0');
		vga_green <= (others => '0');
		vga_blue  <= "1111"; -- Set the pixel to blue 
	   end if;
	   
	   -- P
	   if (hCounter >= amp_h_start+amp_width*2 and hCounter <= amp_h_start+4+amp_width*2 and vCounter = amp_v_start) or -- Top of R
	       (vCounter >= amp_v_start and vCounter <= amp_v_start +amp_height and hCounter = amp_h_start+amp_width*2) or  -- Left side of R
	       (vCounter = amp_v_start+5 and hCounter >= amp_h_start+amp_width*2 and hCounter <= amp_h_start+4+amp_width*2) or -- Bottom of R top
	       (vCounter >= amp_v_start and vCounter <= amp_v_start +5 and hCounter =amp_h_start+4+amp_width*2) then 
                   vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	   end if;
	   
	   
	   -- :
	   if (hCounter >= amp_h_start+1+amp_width*3 and hCounter <= amp_h_start+2+amp_width*3 and vCounter >= amp_v_start+1 and vCounter <= amp_v_start+2) or -- Top of R
	       (hCounter >= amp_h_start+1+amp_width*3 and hCounter <= amp_h_start+2+amp_width*3 and vCounter >= amp_v_start+8 and vCounter <= amp_v_start+9) then 
                   vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	   end if;
           
           
           if amplitude(0) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*4 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- vertical lin
                 (hCounter >= amp_h_start+amp_width*4 and hCounter <= amp_h_start +1+amp_width*4 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*4 and hCounter <= amp_h_start +4+amp_width*4 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*4 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*4 and hCounter <= amp_h_start +4+amp_width*4 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*4 and hCounter <= amp_h_start +4+amp_width*4 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*4 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;
           
           
           if amplitude(1) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*5 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or
                 (hCounter >= amp_h_start+amp_width*5 and hCounter <= amp_h_start +1+amp_width*5 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*5 and hCounter <= amp_h_start +4+amp_width*5 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*5 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*5 and hCounter <= amp_h_start +4+amp_width*5 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*5 and hCounter <= amp_h_start +4+amp_width*5 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*5 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;
           
           
           if amplitude(2) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*6 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or
                 (hCounter >= amp_h_start+amp_width*6 and hCounter <= amp_h_start +1+amp_width*6 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*6 and hCounter <= amp_h_start +4+amp_width*6 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*6 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*6 and hCounter <= amp_h_start +4+amp_width*6 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*6 and hCounter <= amp_h_start +4+amp_width*6 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*6 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;
           
           if amplitude(3) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*7 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or
                 (hCounter >= amp_h_start+amp_width*7 and hCounter <= amp_h_start +1+amp_width*7 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*7 and hCounter <= amp_h_start +4+amp_width*7 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*7 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*7 and hCounter <= amp_h_start +4+amp_width*7 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*7 and hCounter <= amp_h_start +4+amp_width*7 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*7 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;
           
           
           if amplitude(4) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*8 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or
                 (hCounter >= amp_h_start+amp_width*8 and hCounter <= amp_h_start +1+amp_width*8 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*8 and hCounter <= amp_h_start +4+amp_width*8 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*8 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*8 and hCounter <= amp_h_start +4+amp_width*8 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*8 and hCounter <= amp_h_start +4+amp_width*8 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*8 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;
           
           
           if amplitude(5) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*9 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or
                 (hCounter >= amp_h_start+amp_width*9 and hCounter <= amp_h_start +1+amp_width*9 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*9 and hCounter <= amp_h_start +4+amp_width*9 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*9 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*9 and hCounter <= amp_h_start +4+amp_width*9 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*9 and hCounter <= amp_h_start +4+amp_width*9 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*9 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;
           if amplitude(6) = '0' then 
               if (hCounter = amp_h_start +2+amp_width*10 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or
                 (hCounter >= amp_h_start+amp_width*10 and hCounter <= amp_h_start +1+amp_width*10 and vCounter = amp_v_start+2) or 
                 (hCounter >= amp_h_start+amp_width*10 and hCounter <= amp_h_start +4+amp_width*10 and vCounter = amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           else 
               if (hCounter = amp_h_start+amp_width*10 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) or -- left of 0 
                 (hCounter >= amp_h_start+amp_width*10 and hCounter <= amp_h_start +4+amp_width*10 and vCounter = amp_v_start) or   -- top of 0 
                 (hCounter >= amp_h_start+amp_width*10 and hCounter <= amp_h_start +4+amp_width*10 and vCounter = amp_v_start+amp_height) or -- bottom of 0 
                 (hCounter = amp_h_start+4+amp_width*10 and vCounter >= amp_v_start and vCounter <= amp_v_start+amp_height) then 
                  vga_red   <= (others => '0');
	          vga_green <= (others => '0');
	          vga_blue  <= "1111"; -- Set the pixel to blue 
	        end if;
           
           
           end if;

           
           
           
           
           
           
           
           if located = '0' then
           
		   -- white box
		   if (hCounter >=h_start -2 and hCounter <= h_start+2 +80 and vCounter >= v_start -2 and vCounter <=v_start -2+25) then
		       vga_red <= "1111";
		       vga_green <= "1111";
		       vga_blue <= "1111";
		   end if;
		 
		   
		
		    -- S
		    if (hCounter >= h_start and hCounter <= h_start +10 and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +10 and hCounter = h_start) or  -- Middle line of S
		       (vCounter = v_start+10 and hCounter >= h_start and hCounter <= h_start+10) or -- Bottom curve of S
		       (vCounter >= v_start+10 and vCounter <= v_start +20 and hCounter = h_start+10) or  -- Second middle line of S
		       (vCounter = v_start+20 and hCounter >= h_start and hCounter <= h_start+10) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   -- E
		    if (hCounter >= h_start+e_width and hCounter <= h_start +10+e_width and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width) or  -- Middle line of S
		       (vCounter = v_start+10 and hCounter >= h_start+e_width and hCounter <= h_start+10+e_width) or -- Bottom curve of S
		       (hCounter >= h_start+e_width and hCounter <= h_start +10+e_width and vCounter = v_start+20) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   
		   -- A
		    if (hCounter >= h_start+e_width*2 and hCounter <= h_start +10+e_width*2 and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*2) or  -- Middle line of S
		       (vCounter = v_start+10 and hCounter >= h_start+e_width*2 and hCounter <= h_start+10+e_width*2) or -- Bottom curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+10+e_width*2) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   
		   
		   -- R
		   if (hCounter >= h_start+e_width*3 and hCounter <= h_start +10+e_width*3 and vCounter = v_start) or -- Top of R
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*3) or  -- Left side of R
		       (vCounter = v_start+10 and hCounter >= h_start+e_width*3 and hCounter <= h_start+10+e_width*3) or -- Bottom of R top
		       (vCounter >= v_start and vCounter <= v_start +10 and hCounter = h_start+10+e_width*3) or -- Right half of R
		       (vCounter >= v_start+11 and vCounter <= v_start +12 and hCounter = h_start+6+e_width*3) or -- Bottom of R 
		       (vCounter >= v_start+13 and vCounter <= v_start +14 and hCounter = h_start+7+e_width*3) or -- Bottom of R 
		       (vCounter >= v_start+15 and vCounter <= v_start +16 and hCounter = h_start+8+e_width*3) or -- Bottom of R 
		       (vCounter >= v_start+17 and vCounter <= v_start +18 and hCounter = h_start+9+e_width*3) or -- Bottom of R 
		       (vCounter >= v_start+19 and vCounter <= v_start +20 and hCounter = h_start+10+e_width*3) then 
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   -- C
		   if (hCounter >= h_start+e_width*4 and hCounter <= h_start +10+e_width*4 and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*4) or  -- Middle line of S
		       (hCounter >= h_start+e_width*4 and hCounter <= h_start +10+e_width*4 and vCounter = v_start+20) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   
		   -- H
		    if (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*5) or  -- Middle line of S
		       (vCounter = v_start+10 and hCounter >= h_start+e_width*5 and hCounter <= h_start+10+e_width*5) or -- Bottom curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+10+e_width*5) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
	   else 
	           -- white box
		   if (hCounter >=h_start -2 and hCounter <= h_start-2 +67 and vCounter >= v_start -2 and vCounter <=v_start -2+25) then
		       vga_red <= "1111";
		       vga_green <= "1111";
		       vga_blue <= "1111";
		   end if;
		 
		   -- F
		    if (hCounter >= h_start and hCounter <= h_start +10 and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start) or  -- Middle line of S
		       (vCounter = v_start+10 and hCounter >= h_start and hCounter <= h_start+10) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   -- O
		   if (hCounter >= h_start+e_width and hCounter <= h_start +10+e_width and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width) or  -- Middle line of S
		       (hCounter >= h_start+e_width and hCounter <= h_start +10+e_width and vCounter = v_start+20) or -- Bottom curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+10+e_width) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   
		   -- U
		   if (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*2) or  -- Middle line of S
		       (hCounter >= h_start+e_width*2 and hCounter <= h_start +10+e_width*2 and vCounter = v_start+20) or -- Bottom curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+10+e_width*2) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		   
		   
		   -- N
		   if (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*3) or  -- Left of N
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+10+e_width*3) or  -- Right of N
		       (vCounter = v_start and hCounter = h_start+1+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+1 and vCounter <= v_start +2 and hCounter = h_start+2+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+3 and vCounter <= v_start +5 and hCounter = h_start+3+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+6 and vCounter <= v_start +8 and hCounter = h_start+4+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+9 and vCounter <= v_start +11 and hCounter = h_start+5+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+12 and vCounter <= v_start +14 and hCounter = h_start+6+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+15 and vCounter <= v_start +17 and hCounter = h_start+7+e_width*3) or  -- Bottom curve of S
		       (vCounter >= v_start+18 and vCounter <= v_start +19 and hCounter = h_start+8+e_width*3) or  -- Bottom curve of S
		       (vCounter = v_start +20 and hCounter = h_start+9+e_width*3) then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
		
		    -- D
		   if (hCounter >= h_start+e_width*4 and hCounter <= h_start +5+e_width*4 and vCounter = v_start) or -- Top curve of S
		       (vCounter >= v_start and vCounter <= v_start +20 and hCounter = h_start+e_width*4) or  -- Middle line of S
		       (hCounter >= h_start+e_width*4 and hCounter <= h_start +5+e_width*4 and vCounter = v_start+20) or -- Bottom curve of S
		       (vCounter >= v_start+5 and vCounter <= v_start +15 and hCounter = h_start+10+e_width*4) or -- Bottom curve of S
		       
		       (vCounter >= v_start+3 and vCounter <= v_start +4 and hCounter = h_start+9+e_width*4) or -- Bottom curve of S
		       (vCounter >= v_start+16 and vCounter <= v_start +17 and hCounter = h_start+9+e_width*4) or -- Bottom curve of S
		       (vCounter = v_start+2 and hCounter = h_start+8+e_width*4) or -- Bottom curve of S
		       (vCounter = v_start+18 and hCounter = h_start+8+e_width*4) or  -- Middle line of S
		       (hCounter >= h_start+6+e_width*4 and hCounter <= h_start +7+e_width*4 and vCounter = v_start+1) or  -- Middle line of S
		       (hCounter >= h_start+6+e_width*4 and hCounter <= h_start +7+e_width*4 and vCounter = v_start+19)then -- Bottom curve of S
		          vga_red   <= (others => '0');
		          vga_green <= (others => '0');
		          vga_blue  <= "1111"; -- Set the pixel to blue 
		   end if;
	   
	   
	   end if;
           
           
           
           
           
           
           
       
        else
           vga_red   <= (others => '0');
           vga_green <= (others => '0');
           vga_blue  <= (others => '0');
        end if;
   
         if vCounter  >= vRez then
            address <= (others => '0');
            blank <= '1';
         else 
            if hCounter  < 640 then
               blank <= '0';
               address <= address+1;
            else
               blank <= '1';
            end if;
         end if;
   
         -- Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
         if hCounter > hStartSync and hCounter <= hEndSync then
            vga_hSync <= hsync_active;
         else
            vga_hSync <= not hsync_active;
         end if;

         -- Are we in the vSync pulse?
         if vCounter >= vStartSync and vCounter < vEndSync then
            vga_vSync <= vsync_active;
         else
            vga_vSync <= not vsync_active;
         end if;
      end if;
   end process;
end Behavioral;

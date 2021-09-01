--[[
Author:		BigDaddyMoisture aka LordToothpaste
Version:	0.8 
Date: 		30.08.2021

Special thanks to wookiefriseur for the help :)

Keys:
    Win(Super): "lgui"
    L-Alt: "lalt"
    L-Control: "lctrl" ?????
    Arrow-keys: "up", "left", "down", "right"

This script attempts to implement gesture button functionality similar to other logitech mice that have customizable gesture buttons.
The gestures use before and after comparisons of mouse pointer positions.

To execute a gesture move the mouse pointer while holding the special button:
* up to open task view 		(Winkey+Tab)
* down to minimise all windows	(Winkey+D)
* left to move to desktop at relative RIGHT	(Winkey+Ctrl+Right)
* right to move desktop at relative RIGHT	(Winkey+Ctrl+Left)

Mouse buttons:
1=M1,2=M2,3=MMB and so on. For G-buttons, their respective numbers 1:1. 
--]]

button_number = 6; -- Mouse button number
threshold_x = 5000; -- x,y thresholds
threshold_y = 8000; 
show_console_output = false;

-- enable / disable gestures
taskv_on = true;		-- maximise window
min_on = true;		-- minimise window
left_on = true;		-- move to left
right_on = true;	-- move to right

-- inits
pos_x_start, pos_y_start = 0, 0;
pos_x_end, pos_y_end = 0, 0;
pos_string = "";
diff_string = "";

-- Event listener
function OnEvent(event, arg, family)
	if event == "MOUSE_BUTTON_PRESSED" and arg == button_number then
		mb6_pressed = true
		Sleep(30);
		pos_x_start, pos_y_start = GetMousePosition();
		Sleep(20);
        -- Console output text
		pos_string = "x: " .. pos_x_start .. " y: " .. pos_y_start;
	end

	-- 1/09
	if event == "MOUSE_BUTTON_PRESSED" and arg == 4 then
		mb4_pressed = true
	end
	if event == "MOUSE_BUTTON_RELEASED" and arg == 4 then
		mb4_pressed = false
	end

	if event == "MOUSE_BUTTON_PRESSED" and arg == 5 then
		mb5_pressed = true
	end
	if event == "MOUSE_BUTTON_RELEASED" and arg == 5 then
		mb5_pressed = false
	end
	-- end 1/09

	if event == "MOUSE_BUTTON_RELEASED" and arg == button_number then
		mb6_pressed = false
		Sleep(30);
		pos_x_end, pos_y_end = GetMousePosition();
		Sleep(20);
		diff_x = pos_x_end - pos_x_start;
		diff_y = pos_y_start - pos_y_end;
        -- Console output text
        pos_string = "x: " .. pos_x_end .. " y: " .. pos_y_end;
		diff_string = "x: " .. diff_x .. " y: " .. diff_y;

		-- Gestures
		if taskv_on and diff_y > threshold_y then gtaskView() end
		if min_on and diff_y < -threshold_y then gMinimiseAll() end
		if right_on and diff_x > threshold_x then gMoveDesktopLeft() end		
		if left_on and diff_x < -threshold_x then gMoveDesktopRight() end
	end

	-- 1/09
	if event == "MOUSE_BUTTON_RELEASED" and arg == 4 then
		if mb6_pressed == true then dpiDOWN() end
	end

	if event == "MOUSE_BUTTON_RELEASED" and arg == 5 then
		if mb6_pressed == true then dpiUP() end
	end
	-- end 1/09
--OutputLogMessage("event = %s, arg = %s, family=%s\nPosition = %s, Movement= %s \n", event, arg, family,pos_string,diff_string); --debug
end

-- Gesture actions
function gtaskView()
	pressTwoKeys("lgui","tab",20);
	if show_console_output then
     	OutputLogMessage("[TASKVIEW]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
    end
end

function gMinimiseAll()
	pressTwoKeys("lgui","d",20);
        if show_console_output then
        OutputLogMessage("[MINIMISE]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
    end
end

function gMoveDesktopLeft()
	PlayMacro("MoveDesktopLeft");
    	if show_console_output then
     	OutputLogMessage("[MOVE LEFT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function gMoveDesktopRight()
	PlayMacro("MoveDesktopRight");
     if show_console_output then
     	OutputLogMessage("[MOVE RIGHT]\t[Position = %s, Movement= %s ]\n",pos_string,diff_string);
	end
end

function dpiUP()
	PlayMacro("dpiUp");
end

function dpiDOWN()
	PlayMacro("dpiDown");
end

-- Helper functions
function pressTwoKeys(key1,key2,ms)
	PressKey(key1);
	Sleep(ms);
	PressKey(key2);
	Sleep(ms);
	ReleaseKey(key2);
	ReleaseKey(key1);
end

conky.config = {
	-- xinerama_head = 1,
	-- alignment = "top_left",
	background = false,
	border_width = 0,
	default_color = "D1E7D1",
	color0 = "C9CBFF",
	color1 = "D9E0EE",
	color2 = "89DCEB",
	color3 = "F2CDCD",
	color4 = "C3BAC6",
	color5 = "ABE9B3",
	color6 = "FAE3B0",
	cpu_avg_samples = 1,
	default_outline_color = "white",
	default_shade_color = "white",
	double_buffer = true,
	draw_borders = false,
	draw_graph_borders = true,
	draw_outline = false,
	draw_shades = false,
	-- gap_x = 0,
	-- gap_y = 0,
	border_outer_margin = 0,
	max_port_monitor_connections = 64,
	maximum_width = 370,
	-- minimum_width = 370,
	max_user_text = 16384,
	minimum_height = 400,
	net_avg_samples = 2,
	no_buffers = true,
	out_to_console = false,
	-- out_to_x = false,
	-- out_to_wayland = true,
	own_window = true,
	own_window_class = "conky-sys",
	own_window_type = "normal",
	own_window_hints = "undecorated,below,sticky,skip_taskbar,below",
	own_window_transparent = true,
	own_window_argb_value = 200,
	own_window_colour = "black",
	own_window_argb_visual = true,
	update_interval = 1,
	top_cpu_separate = true,
	uppercase = false,
	use_xft = true,
	xftalpha = 0.8,
	font = "JetBrainsMono Nerd Font:size=10",
}

conky.text = [[
${goto 10}${color1}Hostname: ${color}$nodename					${goto 200}${color1}Kernel:${alignr}${color} $kernel
${goto 10}${color1}Uptime:   ${color}$uptime					${goto 200}${color1}Load:${alignr}${color} $loadavg
$hr
${goto 10}${color1}CPU: ${color}${execi 1000 cat /proc/cpuinfo | grep 'model name' | sed -e 's/model name.*: //'| uniq | cut -c -17}		${goto 200}${color1}Temp: ${alignr}${color}${exec "sensors -u k10temp-pci-00c3 | grep temp1_input | cut -c 16-19"}C
${goto 10}${color}${cpugraph 60,360 89B4FA F38BA8 -t}
${goto 10}CPU cores
${goto 10}${color1}1:  ${color}${freq 1}Mhz ${goto 100}${cpubar cpu1 12,80}  	${goto 200}${color1}13: ${color}${freq 13}Mhz ${goto 290}${cpubar cpu9 12,80}
${goto 10}${color1}2:  ${color}${freq 2}Mhz ${goto 100}${cpubar cpu2 12,80}  	${goto 200}${color1}14: ${color}${freq 14}Mhz ${goto 290}${cpubar cpu10 12,80}
${goto 10}${color1}3:  ${color}${freq 3}Mhz ${goto 100}${cpubar cpu3 12,80}  	${goto 200}${color1}15: ${color}${freq 15}Mhz ${goto 290}${cpubar cpu11 12,80}
${goto 10}${color1}4:  ${color}${freq 4}Mhz ${goto 100}${cpubar cpu4 12,80}  	${goto 200}${color1}16: ${color}${freq 16}Mhz ${goto 290}${cpubar cpu12 12,80}
${goto 10}${color1}5:  ${color}${freq 5}Mhz ${goto 100}${cpubar cpu5 12,80}  	${goto 200}${color1}17: ${color}${freq 17}Mhz ${goto 290}${cpubar cpu13 12,80}
${goto 10}${color1}6:  ${color}${freq 6}Mhz ${goto 100}${cpubar cpu6 12,80}  	${goto 200}${color1}18: ${color}${freq 18}Mhz ${goto 290}${cpubar cpu14 12,80}
${goto 10}${color1}7:  ${color}${freq 7}Mhz ${goto 100}${cpubar cpu7 12,80}  	${goto 200}${color1}19: ${color}${freq 19}Mhz ${goto 290}${cpubar cpu15 12,80}
${goto 10}${color1}8:  ${color}${freq 8}Mhz ${goto 100}${cpubar cpu8 12,80}  	${goto 200}${color1}20: ${color}${freq 20}Mhz ${goto 290}${cpubar cpu16 12,80}
$hr
${goto 10}${color1}Water:       ${color}${exec "sensors -u asusec-isa-0000 | grep -o 'temp4_input: [0-9]\{1,4\}' | cut -c 14-"}C	${goto 200}${color1}Pump:${alignr}${color}${exec "sensors -u nct6798-isa-0290 | grep -o 'fan6_input: [0-9]\{1,4\}' | cut -c 13-"}RPM
${goto 10}${color1}Top Fans:    ${color}${exec "sensors -u nct6798-isa-0290 | grep -o 'fan2_input: [0-9]\{1,4\}' | cut -c 13-"}RPM	${goto 200}${color1}Bottom Fans${alignr}${color}${exec "sensors -u nct6798-isa-0290 | grep -o 'fan3_input: [0-9]\{1,4\}' | cut -c 13-"}RPM
$hr
${goto 10}${color1}RAM: ${color}$memperc%					${alignr}$mem / $memmax
${goto 10}${color}${memgraph 75,360 89B4FA F38BA8 -t}
$hr
${goto 10}${color1}GPU:  ${color}${exec "nvidia-smi --query-gpu=name --format=csv,noheader | sed s/NVIDIA\ //g"}			${color1}${goto 200}VRAM: ${alignr}${color}${exec "nvidia-smi --query-gpu=memory.used --format=csv,noheader"}
${goto 10}${color1}Temp: ${color}${exec "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"}C	${color1}${goto 200}Power: ${alignr}${color}${exec "nvidia-smi | grep -Eo '...%.+?W' | awk '{print $4}'"}
${goto 10}${color}${execgraph "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | rev | cut -c 2- | rev" 60,360 89B4FA F38BA8 -t}
$hr
${goto 10}${color1}File systems:
${goto 10}${color1}root   ${color}${fs_free /}${color1}			${goto 200}${color1}storage ${alignr}${color}${fs_free /mnt/storage}
${goto 10}${color1}Read:  ${color}${diskio_read /dev/nvme0n1p2}		${goto 200}${color1}Read:   ${alignr}${color}${diskio_read /dev/nvme1n1p1}
${goto 10}${color1}Write: ${color}${diskio_write /dev/nvme0n1p2}	${goto 200}${color1}Write:  ${alignr}${color}${diskio_write /dev/nvme1n1p1}
${goto 10}${diskiograph /dev/nvme0n1p2 60,170 89B4FA F38BA8 -t}		${goto 200}${diskiograph /dev/nvme1n1p1 60,170 89B4FA F38BA8 -t}
${goto 10}${color1}data   ${color}${fs_free /mnt/data}			${goto 200}${color1}media   ${alignr}${color}${fs_free /mnt/media}
$hr
${goto 10}${color1}Network: ${color}enp5s0
${goto 10}${color1}Download: ${color}${downspeed enp5s0}			${goto 200}${color1}Upload: ${alignr}${color}${upspeed enp5s0}
${goto 10}${downspeedgraph enp5s0 60,170 89B4FA F38BA8 -t}		${goto 200}${upspeedgraph enp5s0 60,170 89B4FA F38BA8 -t}
$hr
${goto 10}${color1}Top Process by CPU:
${goto 10}${color1}Name              PID     CPU%  ${alignr}MEM%
${goto 10}${color}${top name 1} ${top pid 1} ${top cpu 1} ${alignr}${top mem_res 1}
${goto 10}${color}${top name 2} ${top pid 2} ${top cpu 2} ${alignr}${top mem_res 2}
${goto 10}${color}${top name 3} ${top pid 3} ${top cpu 3} ${alignr}${top mem_res 3}
${goto 10}${color}${top name 4} ${top pid 4} ${top cpu 4} ${alignr}${top mem_res 4}
${goto 10}${color}${top name 5} ${top pid 5} ${top cpu 5} ${alignr}${top mem_res 5}
$hr
${goto 10}${color1}Top Process by Memory:
${goto 10}${color1}Name              PID     CPU%  ${alignr}MEM%
${goto 10}${color}${top_mem name 1} ${top_mem pid 1} ${top_mem cpu 1} ${alignr}${top_mem mem_res 1}
${goto 10}${color}${top_mem name 2} ${top_mem pid 2} ${top_mem cpu 2} ${alignr}${top_mem mem_res 2}
${goto 10}${color}${top_mem name 3} ${top_mem pid 3} ${top_mem cpu 3} ${alignr}${top_mem mem_res 3}
${goto 10}${color}${top_mem name 4} ${top_mem pid 4} ${top_mem cpu 4} ${alignr}${top_mem mem_res 4}
${goto 10}${color}${top_mem name 5} ${top_mem pid 5} ${top_mem cpu 5} ${alignr}${top_mem mem_res 5}
]]

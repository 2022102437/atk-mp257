ST_SPECIFIC_BOARD=1

# for stm32mp257f-ev1 board, the interface end0 (aka ethernet0.eth2) need to be desactivated during
# the init of syspl

st_board_specific_before() {
	networkctl down end0
}

st_board_specific_after() {
	networkctl up end0
}

# Set up trackball (boost scroll and slow down pointer)
DEV='Kensington Kensington Slimblade Trackball'
if xinput list | grep -q "$DEV"; then
	# multiply scroll wheel inputs (binding in ~/.xbindkeysrc)
	xinput set-button-map "$DEV" 1 8 3 9 10 6 7 2
	xbindkeys
	# slow down pointer
	PTR_SPEED='0.850000'
	xinput set-prop "$DEV" 'Coordinate Transformation Matrix' "$PTR_SPEED", 0.000000, 0.000000, 0.000000, "$PTR_SPEED", 0.000000, 0.000000, 0.000000, 1.000000
fi

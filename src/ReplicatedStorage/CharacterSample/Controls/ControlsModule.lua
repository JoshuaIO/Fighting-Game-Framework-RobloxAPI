local controlsTable = {
	buttonOne="q",
	buttonTwo="h",
	buttonThree="j",
	buttonFour="b",
	buttonFive="n",
	buttonSix="m",
	
}

function controlsTable.ControlProcessor(key)
	local processKey = Enum.KeyCode[string.upper(key)]
	return processKey
end

return controlsTable

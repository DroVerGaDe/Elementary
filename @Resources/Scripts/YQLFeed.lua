function Initialize()
	
	newMinutes = tonumber(SKIN:GetVariable('NewMinutes'))
	-- newColor = SKIN:GetVariable('NewEntryColor')
	-- oldColor = SKIN:GetVariable('OldEntryColor')
end

function Update()

end

function CheckNew(measureArg, meterArg, measureAgeArg)

	local timeMeasure = SKIN:GetMeasure(measureArg)
	local timeString = timeMeasure:GetStringValue()
	local timeDifference = os.time(os.date('!*t')) - TimeStamp(timeString)
	
	local timeDifferenceFormat = ConvertSeconds(timeDifference)
	if timeDifferenceFormat['mins'] == 1 then minText = "minute" else minText="minutes" end
	if timeDifferenceFormat['hours'] == 1 then	hourText = "hour" else hourText="hours" end
	if timeDifferenceFormat['days'] == 1 then dayText = "day" else dayText="days" end
	
	if timeDifference <= 86400 then
		if timeDifference < 3600 then
			ageDisplay = timeDifferenceFormat['mins']..' '..minText..' ago'
		else	
			ageDisplay = timeDifferenceFormat['hours']..' '..hourText..' '..timeDifferenceFormat['mins']..' '..minText..' ago'
		end	
	else
		ageDisplay = timeDifferenceFormat['days']..' '..dayText..' '..timeDifferenceFormat['hours']..' '..hourText..' '..timeDifferenceFormat['mins']..' '..minText..' ago'
	end

	SKIN:Bang('!SetOption', measureAgeArg, 'Format', ageDisplay)	
	
	if timeDifference / 60 <= newMinutes then
		SKIN:Bang('!SetOption', meterArg, 'FontColor', '#highlight#')
	else
		SKIN:Bang('!SetOption', meterArg, 'FontColor', '#color#')
	end	

	SKIN:Bang('!UpdateMeter', '*')
	SKIN:Bang('!Redraw')

end

function TimeStamp(itemDate)

	-- Feed date format : 2013-12-07T01:23:32Z
	local year, month, day, hour, min, sec, zone =		
		string.match(itemDate, "(.-)-(.-)-(.-)T(.-):(.-):(.-)(.-)")
	
	return os.time({year=year, month=month, day=day, hour=hour, min=min, sec=sec, isdst=false})

end

function ConvertSeconds(secondsDiff)
    
	local daysDiff = (secondsDiff / 86400)
	local daysRemainder = (secondsDiff % 86400)
	local hoursDiff = (daysRemainder / 3600)
	local hoursRemainder = ((secondsDiff - 86400) % 3600)
	local minsDiff = (hoursRemainder / 60)
	
	local tConvertSeconds = {days = math.floor(daysDiff); hours = math.floor(hoursDiff); mins = math.floor(minsDiff)}	
	
	return tConvertSeconds
	
end

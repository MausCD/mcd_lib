MCD.Math = {}

MCD.Math.Range = function(value , min , max)
    value = math.floor(value * 100)
   
    if value >= math.floor(min * 100) and value <= math.floor(max * 100) then
        return true
    else
        return false
    end
end

MCD.Math.TimeDifference = function(t1 , t2 , inms)
    local seconds = 0
    if os then
        if inms then
            seconds = (t1 - t2)*1000 * -1
        else
            seconds = (t1 - t2)/1 * -1
        end
    else
        if inms then
            seconds = (t1 - t2) * -1
        else
            seconds = (t1 - t2)/1000 * -1
        end
    end
    return math.floor(seconds)
end

MCD.Math.Dist = function(c1 , c2 , md)
    return #(c1 - c2) <= md
end

MCD.Math.MDist = function(c1 , c2 , md)
    if md < 0.5 then md = 0.5 end
    return #(c1 - c2) <= md
end


MCD.Math.Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

MCD.Math.GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. _U('locale_digit_grouping_symbol')):reverse())..right
end
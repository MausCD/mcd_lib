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
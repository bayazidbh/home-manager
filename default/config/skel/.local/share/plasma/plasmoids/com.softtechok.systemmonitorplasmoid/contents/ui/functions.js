function convertBinary(v, unit) {
    if (typeof v == 'undefined')
        v = 0;
    switch(unit % 100) {
        case 1 :
            v = v * 1024;
            break;
        case 2 :
            v = v * 1048576;
            break;
        case 3 :
            v = v * 1073741824;
            break;
        case 4 :
            v = v * 1099511627776;
            break;
        case 5 :
            v = v * 1125899906842624;
            break;
    }
    return v;
}
function convertDecimal(v, unit) {
    if (typeof v == 'undefined')
        v = 0;
    switch(unit % 100) {
        case 1 :
            v = v * 1000;
            break;
        case 2 :
            v = v * 1000000;
            break;
        case 3 :
            v = v * 1000000000;
            break;
        case 4 :
            v = v * 1000000000000;
            break;
        case 5 :
            v = v * 1000000000000000;
            break;
    }
    return v;
}
function convert(v, unit) {
    switch (Math.floor(unit / 100)) {
        case 3:
            return convertDecimal(v, unit);
        default:
            return convertBinary(v, unit);
    }
}
function getBinDivisor(v) {
    const unitSymbol = [0, ""];

    unitSymbol[0] = 1125899906842624;
    unitSymbol[1] = "Pi";
    if (v >= 1125899906842624)
        return unitSymbol;
    unitSymbol[0] = 1099511627776;
    unitSymbol[1] = "Ti";
    if (v >= 1099511627776)
        return unitSymbol;
    unitSymbol[0] = 1073741824;
    unitSymbol[1] = "Gi";
    if (v >= 1073741824)
        return unitSymbol;
    unitSymbol[0] = 1048576;
    unitSymbol[1] = "Mi";
    if (v >= 1048576)
        return unitSymbol;
    unitSymbol[0] = 1024;
    unitSymbol[1] = "Ki";
    if (v >= 1024 )
        return unitSymbol;
    unitSymbol[0] = 1;
    unitSymbol[1] = " i";
    return unitSymbol;
}
function getDecDivisor(v) {
    const unitSymbol = [0, ""];

    unitSymbol[0] = 1000000000000000;
    unitSymbol[1] = "P";
    if (v >= 1000000000000000)
        return unitSymbol;
    unitSymbol[0] = 1000000000000;
    unitSymbol[1] = "T";
    if (v >= 1000000000000)
        return unitSymbol;
    unitSymbol[0] = 1000000000;
    unitSymbol[1] = "G";
    if (v >= 1000000000)
        return unitSymbol;
    unitSymbol[0] = 1000000;
    unitSymbol[1] = "M";
    if (v >= 1000000)
        return unitSymbol;
    unitSymbol[0] = 1000;
    unitSymbol[1] = "K";
    if (v >= 1000 )
        return unitSymbol;
    unitSymbol[0] = 1;
    unitSymbol[1] = " ";
    return unitSymbol;
}
function getDivisor(v, unit) {
    switch (Math.floor(unit / 100)) {
        case 3:
            return getDecDivisor(v);
        case 6:
            return getDecDivisor(v);
        case 7:
            return getDecDivisor(v);
        case 8:
            return getDecDivisor(v);
        case 10:
            return getDecDivisor(v);
        default:
            return getBinDivisor(v);
    }
}
function format(v, unit, width, suffix) {
    return (v / unit[0]).toFixed(2).padStart(width, ' ') + " " + unit[1] + suffix;
}

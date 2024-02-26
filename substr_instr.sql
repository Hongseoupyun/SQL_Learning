-- This SQL script is designed to select specific data from a generic network diagram data table.
-- The data is filtered based on certain criteria and then ordered numerically by IP address, despite the IP address being stored as a string.

-- Selection Criteria:
-- The query filters records based on a matching sheet name, a specific identifier value, a network value, and a LoadID pattern indicating a specific preload date.

SELECT 
    column_row, 
    column_identifier, 
    column_ipaddress, 
    column_devicename, 
    column_networkvalue, 
    column_devicetype, 
    column_loadid 
FROM 
    network_diagram_data_table 
WHERE 
    column_sheetname = 'SheetNamePlaceholder' 
    AND column_identifier = 'IdentifierPlaceholder'
    AND column_networkvalue = 'NetworkValuePlaceholder'
    AND column_loadid LIKE 'LoadIDPatternPlaceholder'
ORDER BY 
    column_ipaddress;  -- This orders the records lexicographically by IP address, which is not numerically accurate for IPs.

-- To accurately order IP addresses numerically, each octet of the IP address must be extracted and converted to a numeric value.
-- This is achieved through the use of SUBSTR and INSTR functions in the ORDER BY clause, despite the column_ipaddress field being stored as a string.

SELECT 
    column_row, 
    column_identifier, 
    column_ipaddress, 
    column_devicename, 
    column_networkvalue, 
    column_devicetype, 
    column_loadid 
FROM 
    network_diagram_data_table 
WHERE 
    column_sheetname = 'SheetNamePlaceholder' 
    AND column_identifier = 'IdentifierPlaceholder'
    AND column_networkvalue = 'NetworkValuePlaceholder'
    AND column_loadid LIKE 'LoadIDPatternPlaceholder'
ORDER BY 
    TO_NUMBER(SUBSTR(column_ipaddress, 1, INSTR(column_ipaddress, '.') - 1)),
    TO_NUMBER(SUBSTR(column_ipaddress, INSTR(column_ipaddress, '.', 1, 1) + 1, INSTR(column_ipaddress, '.', 1, 2) - INSTR(column_ipaddress, '.', 1, 1) - 1)),
    TO_NUMBER(SUBSTR(column_ipaddress, INSTR(column_ipaddress, '.', 1, 2) + 1, INSTR(column_ipaddress, '.', 1, 3) - INSTR(column_ipaddress, '.', 1, 2) - 1)),
    TO_NUMBER(SUBSTR(column_ipaddress, INSTR(column_ipaddress, '.', 1, 3) + 1));

-- Explanation of the Numerical Ordering Logic:
-- IP addresses are stored as strings in the format 'xxx.xxx.xxx.xxx'. To sort them numerically, each octet must be considered individually.
-- The SUBSTR function extracts parts of the string based on starting positions and lengths.
-- The INSTR function is used to find the positions of the '.' characters, which separate the octets.
-- By calculating the positions of these dots and extracting the numeric values between them, we can accurately order the IP addresses.

-- This approach ensures that IP addresses are sorted numerically, allowing for correct order based on their actual numeric value rather than a lexicographical comparison.

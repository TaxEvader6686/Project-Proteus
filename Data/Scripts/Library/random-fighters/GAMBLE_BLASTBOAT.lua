return {
    --Min/Max_Year Values required, can be any integer
    --Research optional, if not needed put 'nil'
    --Research is the FighterResearch that has to be set for that Fighter to be added to the pool

    --["PROTEUS_GROUP_NAME"] = {
        --["OPTION1"] = {Min_Year = X, Max_Year = X, Research = "FighterResearch"},
        --["OPTION2"] = {Min_Year = X, Max_Year = X, Research = "FighterResearch"},
        --["OPTION3"] = {Min_Year = X, Max_Year = X, Research = "FighterResearch"},
        --...
    --},
     ["IMPERIAL_LIANNA"] = {
        ["EARLY_SKIPRAY_SQUADRON"] = {
            Min_Year = 1, Max_Year = 20, Research = nil
        },
        ["SKIPRAY_SQUADRON"] = {
            Min_Year = 1, Max_Year = 20, Research = nil
        },
        ["ADVANCED_SKIPRAY_SQUADRON"] = {
            Min_Year = 1, Max_Year = 20, Research = nil
        },
        ["SKIPRAY_INTERCEPTOR_SQUADRON"] = {
            Min_Year = 1, Max_Year = 20, Research = nil
        },
     }   
}

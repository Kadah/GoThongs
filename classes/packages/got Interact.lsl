// Wrapper for jas Interact to make the got impelementation more portable

/*
    
    Handles interaction inputs from things like books
    
    GoT Specific:
    - STDIN: Sends a LocalConf$interact to the prim
    - LVIN: Has the level raise an event
    - book$id - Loads a book
*/
#define InteractConf$usePrimSwim
#define InteractConf$maxRate 0.5
#define InteractConf$soundOnFail "ea0ab603-63f5-6377-21bb-552aa4ba334f"
#define InteractConf$soundOnSuccess "31086022-7f9a-65d1-d1a7-05571b8ea0f2"
#define InteractConf$ignoreUnsit
#define InteractConf$allowWhenSitting
#define InteractConf$raiseEvent

#define USE_EVENT_OVERRIDE
#include "got/_core.lsl"
#define InteractConf$ALLOW_ML_LCLICK

key level = "";
integer CROSSHAIR;
integer onInteract(key obj, string task, list params){
    if(task == "book"){
        SharedMedia$setBook(llList2String(params, 0));
    }
    else if(task == "STDIN"){
		// Real key is the key of the link that was interacted with, usually the same key as obj but might be a sub-link when ROOT is used
        LocalConf$stdInteract(obj, llGetOwner(), [real_key]);
    }
    else if(task == "LVIN"){
        runMethod(level, "got Level", LevelMethod$interact, [obj, mkarr(params)], TNN);
    }
	else if(task == "CLEAR_CAM"){
		RLV$clearCamera((str)LINK_ROOT);
	}
	/*
    else if(task == "CUSTOM"){
        raiseEvent(InteractEvt$onInteract, mkarr(([obj, task])));
    }
	*/
    else 
		return FALSE;
	return TRUE;
}
onDesc(key obj, string text){
    if(text == "CUSTOM")text = "Coop Player";
    
    if(obj == "_PRIMSWIM_CLIMB_"){
        obj = llGetKey();
        text = "[E] Climb Out";
    }
    else{
		text = "[E] "+text;
	}
	
    if(obj){
        llSetLinkPrimitiveParamsFast(CROSSHAIR, [PRIM_SIZE, <0.05, 0.05, 0.05>, PRIM_TEXT, text, <1,1,1>, 1, PRIM_ROT_LOCAL, llEuler2Rot(<0,-PI_BY_TWO,0>)]);
    }
    else
        llSetLinkPrimitiveParamsFast(CROSSHAIR, [PRIM_SIZE, ZERO_VECTOR, PRIM_TEXT, "", ZERO_VECTOR, 0, PRIM_ROT_LOCAL, ZERO_ROTATION]);
}

evt(string script, integer evt, list data){
    if(script == "#ROOT"){
        if(evt == RootEvt$level)level = llList2String(data,0);
        else if(evt == RootEvt$players){
            additionalAllow = data;
            if(llList2Key(additionalAllow, 0) == llGetOwner())additionalAllow = llDeleteSubList(additionalAllow,0,0);
        }
    }
}

integer preInteract(key obj){
    return TRUE;
}
onInit(){
    links_each(nr, name, if(name == "CROSSHAIR"){CROSSHAIR = nr;})
}
#include "xobj_core/classes/packages/jas Interact.lsl"



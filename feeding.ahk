#Requires AutoHotkey v2.0

#Include "lib\libCommon.ahk"

FEED_INITIAL_DELAY_MS := 600000 ; 5 min
FEED_NEXT_DELAY_MS := 1500000 ; 25 min
FEED_RETRY_ACTION_DELAY_MS := 120000 ; 2 min
FEED_RETRY_MENU_DELAY_MS := 60000 ; 1 min
FEED_FOOD_DELAY_MS := 5000

FEED_FOOD_1_BUTTON := 4
FEED_FOOD_2_BUTTON := 5

SetTimer TimeToFeed, FEED_INITIAL_DELAY_MS


; ====================================================================
; Checks it is possible to feed character right now.
; If not retries in some short period again.
;
TimeToFeed()
{
    if isOnAction() {
        SetTimer TimeToFeed, FEED_RETRY_ACTION_DELAY_MS
        Log("Feeding: character is busy - some action in process")
    }
    else if !isOnGamingScreen() {
        SetTimer TimeToFeed, FEED_RETRY_MENU_DELAY_MS
        Log("Feeding: character is busy - not on gaming screen")
    }
   else {
        FeedCharacter()
    }
}


; ====================================================================
; Feeds character.
;
FeedCharacter()
{
    Send(FEED_FOOD_1_BUTTON)
    Sleep(FEED_FOOD_DELAY_MS)
    Send(FEED_FOOD_2_BUTTON)
    SetTimer TimeToFeed, FEED_NEXT_DELAY_MS
    Log("Feeding: Done")
}

TimeToFeed()
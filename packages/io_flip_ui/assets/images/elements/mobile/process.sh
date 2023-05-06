ELEMENTS="air earth fire metal water";

for ELEMENT in $ELEMENTS
do
    cd $ELEMENT;
    convert charge_back.png -crop 5x4@ +repage +adjoin charge_back-split_%d.png;
    echo "charge_front.png";
    echo "damage_receive.png";
    echo "damage_send.png";
    echo "victory_charge_back.png";
    echo "victory_charge_front.png";
    cd ..;
done

# convert roguelikeSheet_transparent.png -crop 57x31-1-1@ +repage +adjoin spaced-1_%d.png
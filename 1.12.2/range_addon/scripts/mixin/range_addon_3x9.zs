#loader mixin

import mixin.CallbackInfoReturnable;
import native.com.buuz135.industrial.utils.WorkUtils;

#mixin {targets: "net.ndrei.teslacorelib.tileentities.SidedTileEntity"}
zenClass MixinTeslaCoreAddonSlot {

    #mixin Inject{method: "isValidAddonItem", at: {value: "HEAD"}, cancellable: true}
    function allowCustomRangeAddon(stack as native.net.minecraft.item.ItemStack, cir as CallbackInfoReturnable) as void {

        val registryName = stack.getItem().getRegistryName();

        if (registryName != null
            && registryName.toString() == "ftbinteractionsremastered:range_addon_3x9") {

            cir.setReturnValue(true);
        }
    }
}

#mixin {targets: "com.buuz135.industrial.tile.WorkingAreaElectricMachine"}
zenClass MixinIFCustomRange {

    #mixin Inject{method: "getWorkingArea", at: {value: "HEAD"}, cancellable: true}
    function customRange(cir as CallbackInfoReturnable) as void {

        val handler = this0.getAddonItems();

        if (handler == null) return;

        var found as bool = false;

        var rangeSide as int = 1;
        var rangeLen as int = 9;

        val slotsCount as int = handler.getSlots();

        for i in 0 .. slotsCount {

            val index as int = i;
            val stack = handler.getStackInSlot(index);

            val registryName = stack.getItem().getRegistryName();

            if (registryName != null
                && registryName.toString() == "datrat:range_addon_3x9") {

                found = true;

                val tag = stack.getTagCompound();

                if (tag != null) {

                    if (tag.hasKey("rangeSide", 3)) {
                        rangeSide = tag.getInteger("rangeSide");
                    }

                    if (tag.hasKey("rangeLen", 3)) {
                        rangeLen = tag.getInteger("rangeLen");
                    }
                }

                break;
            }
        }

        if (!found) return;

        if (rangeSide < 0) {
            rangeSide = 0;
        }

        if (rangeLen < 1) {
            rangeLen = 1;
        }

        val directionIndex as int =
            this0.getFacing().getOpposite().getIndex();

        var dx as int = 0;
        var dz as int = 0;


        if (directionIndex == 2) {
            dz = -1; // NORTH
        }
        else if (directionIndex == 3) {
            dz = 1; // SOUTH
        }
        else if (directionIndex == 4) {
            dx = -1; // WEST
        }
        else if (directionIndex == 5) {
            dx = 1; // EAST
        }
        else {
            return; // UP or DOWN
        }

        val center as double = ((rangeLen + 1) as double) / 2.0;
        val along as double = ((rangeLen - 1) as double) / 2.0;
        val lateral as double = rangeSide as double;

        var growX as double = lateral;
        var growZ as double = lateral;

        if (dx != 0) {
            growX = along;
        }

        if (dz != 0) {
            growZ = along;
        }

        val offsetX as double =
            (dx as double) * center;

        val offsetZ as double =
            (dz as double) * center;

        val pos = this0.getPos();

        val maxY as double =
            (pos.getY() as double)
            + 1.0
            + (this0.getHeight() as double);

        cir.setReturnValue(
            WorkUtils.generateBlockSizeBox(pos)
                .offset(offsetX, 0.0, offsetZ)
                .grow(growX, 0.0, growZ)
                .setMaxY(maxY)
        );
    }
}

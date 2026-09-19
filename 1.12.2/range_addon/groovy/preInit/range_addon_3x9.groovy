import net.ndrei.teslacorelib.items.BaseAddon
import net.ndrei.teslacorelib.tileentities.SidedTileEntity
import com.buuz135.industrial.tile.WorkingAreaElectricMachine

def addon = new BaseAddon(
    "datrat",
    creativeTab("misc"),
    "range_addon_3x9"
) {
    @Override
    boolean canBeAddedTo(SidedTileEntity machine) {
        return machine instanceof WorkingAreaElectricMachine
            && machine.canAcceptRangeUpgrades()
            && !machine.getAddons().any { it.is(this) }
    }
}

addon.setMaxStackSize(1)

content.registerItem(null, addon)

# LuckPerms Setup Guide

LuckPerms is a permissions plugin that manages what commands players can use.
It generates its config on first boot — the commands below should be run **in-game or via server console** after the server starts with LuckPerms installed.

## Initial Setup Commands

Run these commands in the server console or as an OP player:

### 1. Grant SimpleClaims Party Permissions to All Players

The SimpleClaims party commands (`/scp invite-accept`, `/scp create`, etc.) require permission nodes that non-admin players don't have by default. This is why group invites fail for regular players.

```
/lp group default permission set simpleclaimsparty.invite-accept true
/lp group default permission set simpleclaimsparty.create-party true
/lp group default permission set simpleclaimsparty.party-leave true
/lp group default permission set simpleclaimsparty.party-invite true
/lp group default permission set simpleclaimsparty.chat-toggle true
```

Or grant all party commands at once:
```
/lp group default permission set simpleclaimsparty.* true
```

### 2. Grant SimpleClaims Chunk Claiming to All Players
```
/lp group default permission set simpleclaimschunk.* true
```

### 3. Mount Permissions (Zone-Gated Progression)

With `usePerMountPermissions: true` in Mounts+ config, each mount requires its permission node.
Grant mounts progressively as players reach new zones:

```
# All players start with Wolf (Zone 1 starter mount)
/lp group default permission set mounts.wolf_black true

# Create zone-based groups and assign mount permissions
/lp creategroup zone2
/lp group zone2 permission set mounts.bear_polar true

/lp creategroup zone3
/lp group zone3 permission set mounts.rex_cave true

/lp creategroup zone4
/lp group zone4 permission set mounts.dragon_frost true
```

**To promote a player when they reach a new zone:**
```
/lp user <player> parent add zone2
/lp user <player> parent add zone3
/lp user <player> parent add zone4
```

### 4. AdminUI + LuckPerms Integration

AdminUI and LuckPerms are both made by Buuz135 and use Hytale's native `PermissionsModule`. AdminUI depends on `Hytale:AccessControlModule`. LuckPerms hooks into the same permission system, so permissions set via LuckPerms commands are respected by AdminUI's permission checks.

**AdminUI permission nodes** (for reference — typically admin-only):
| Permission | Description |
|------------|-------------|
| `AdminUI.ui.open` | Open main admin panel |
| `AdminUI.player.open` | Player management |
| `AdminUI.ban.open` | Ban management |
| `AdminUI.mute.open` | Mute management |
| `AdminUI.whitelist.open` | Whitelist management |
| `AdminUI.warp.open` | Warp management |
| `AdminUI.stats.open` | Server stats |
| `AdminUI.backup.open` | Backup management |
| `AdminUI.adminstick` | Admin stick usage |

You can manage these via LuckPerms:
```
/lp group default permission set AdminUI.ui.open false
/lp creategroup moderator
/lp group moderator permission set AdminUI.* true
```

### Key LuckPerms Commands Reference
| Command | Description |
|---------|-------------|
| `/lp` | Main help menu |
| `/lp user <player> info` | View player's permissions |
| `/lp user <player> permission set <node> <true/false>` | Set a permission |
| `/lp user <player> parent add <group>` | Add player to a group |
| `/lp group <group> permission set <node> <true/false>` | Set group permission |
| `/lp creategroup <name>` | Create a new group |
| `/lp listgroups` | List all groups |
| `/lp editor` | Open the web editor (if available) |

### All SimpleClaims Permission Nodes (Reference)
**Party Protection (set per-party in GUI):**
- `simpleclaims.party.protection.invite_players`
- `simpleclaims.party.protection.claim_unclaim`
- `simpleclaims.party.protection.break_blocks`
- `simpleclaims.party.protection.place_blocks`
- `simpleclaims.party.protection.interact`
- `simpleclaims.party.protection.interact.chest`
- `simpleclaims.party.protection.interact.door`
- `simpleclaims.party.protection.interact.bench`
- `simpleclaims.party.protection.interact.chair`
- `simpleclaims.party.protection.interact.portal`
- `simpleclaims.party.protection.friendly_fire`
- `simpleclaims.party.protection.pvp`
- `simpleclaims.party.protection.allow_entry`
- `simpleclaims.party.protection.modify_info`
- `simpleclaims.party.protection.add_allies`

**Admin-only:**
- `simpleclaims.admin.*`

# Watchlist & Favorites - Debugging Guide

## Current Status

✅ **Data IS saving to Firestore** - Confirmed by logs
❓ **UI not updating immediately** - Need to verify

## Debug Logs to Check

### When Adding to Watchlist/Favorites:

You should see this sequence in the console:

```
🔵 Adding to watchlist: userId=..., profileId=..., contentId=278
🔵 Updating Firestore with watchlist: [1403, 533533, ..., 278]
✅ Firestore updated successfully
✅ Added to watchlist successfully
🔍 isInWatchlist(278): true, currentProfile: YourName, watchlist: [1403, 533533, ..., 278]
```

### What Each Log Means:

| Icon | Meaning |
|------|---------|
| 🔵 | Operation starting |
| ✅ | Operation successful |
| ❌ | Error occurred |
| ⚠️ | Warning (e.g., already in list) |
| 🔍 | State check |

## Troubleshooting Steps

### 1. Check if Data is Saving

**Look for:**
```
✅ Firestore updated successfully
✅ Added to watchlist successfully
```

**If you see these:** Data IS saving to Firestore ✅

**If you DON'T see these:** Check for error messages with ❌

### 2. Check if State is Updating

**Look for:**
```
🔍 isInWatchlist(278): true
```

**If it shows `true`:** State updated correctly ✅

**If it shows `false`:** State not updating - check `notifyListeners()`

### 3. Check if UI is Rebuilding

The `Consumer2<AuthProvider, ProfileProvider>` should rebuild when `ProfileProvider` calls `notifyListeners()`.

**To verify:**
- Add an item to watchlist
- Check console for `🔍 isInWatchlist` logs
- The button should change from `Icons.add` to `Icons.check`
- The button border should change color

### 4. Check Watchlist Screen

When you navigate to "My List" screen:

**Expected logs:**
```
🔍 isInWatchlist(278): true, currentProfile: YourName, watchlist: [278, ...]
```

**The screen should:**
- Load immediately with `didChangeDependencies()`
- Show all items in the watchlist
- Update when you add/remove items

## Common Issues & Solutions

### Issue 1: Data Saves but UI Doesn't Update

**Symptoms:**
- ✅ Firestore logs show success
- ❌ Button doesn't change appearance
- ❌ Item doesn't appear in "My List"

**Solution:**
- Check if `notifyListeners()` is being called
- Verify `Consumer2` is wrapping the buttons
- Hot restart the app (not hot reload)

### Issue 2: UI Updates but Data Doesn't Persist

**Symptoms:**
- ✅ Button changes appearance
- ❌ After app restart, item is gone
- ❌ No Firestore success logs

**Solution:**
- Check for ❌ error logs
- Verify Firebase is initialized
- Check Firestore security rules

### Issue 3: Duplicate Items in List

**Symptoms:**
- Same item appears multiple times
- Logs show: `⚠️ Content already in watchlist`

**Solution:**
- The code already prevents duplicates
- If you see this, the item was already added
- This is expected behavior

### Issue 4: Profile Not Found

**Symptoms:**
- Logs show: `❌ Profile not found in local list`
- Nothing saves

**Solution:**
- Ensure you've selected a profile
- Check `profileProvider.currentProfile` is not null
- Create a profile if none exists

## Testing Checklist

### Basic Functionality:
- [ ] Click "My List" button on content detail screen
- [ ] Check console for 🔵 and ✅ logs
- [ ] Verify button changes from `+` to `✓`
- [ ] Navigate to "My List" screen
- [ ] Verify item appears in the list
- [ ] Click button again to remove
- [ ] Verify item disappears from list

### Data Persistence:
- [ ] Add item to watchlist
- [ ] Close app completely
- [ ] Reopen app
- [ ] Select same profile
- [ ] Navigate to "My List"
- [ ] Verify item is still there

### Multi-Profile:
- [ ] Add item to watchlist on Profile A
- [ ] Switch to Profile B
- [ ] Verify item is NOT in Profile B's list
- [ ] Switch back to Profile A
- [ ] Verify item IS in Profile A's list

## Expected Console Output

### Successful Add to Watchlist:
```
🔵 Adding to watchlist: userId=fsR9TuTwFqV5pahFcsj20m59oTY2, profileId=1765017586291, contentId=278
🔵 Updating Firestore with watchlist: [1403, 533533, 70796, 1180831, 210318, 1317288, 79744, 282471, 1084242, 278]
✅ Firestore updated successfully
✅ Added to watchlist successfully
🔍 isInWatchlist(278): true, currentProfile: Dinesh, watchlist: [1403, 533533, 70796, 1180831, 210318, 1317288, 79744, 282471, 1084242, 278]
```

### Successful Add to Favorites:
```
🔵 Adding to favorites: userId=fsR9TuTwFqV5pahFcsj20m59oTY2, profileId=1765017586291, contentId=278
🔵 Updating Firestore with favorites: [1403, 533533, 70796, 1317288, 79744, 282471, 1084242, 278]
✅ Firestore updated successfully
✅ Added to favorites successfully
🔍 isInFavorites(278): true, currentProfile: Dinesh, favorites: [1403, 533533, 70796, 1317288, 79744, 282471, 1084242, 278]
```

## Firestore Structure

Your data should look like this in Firestore:

```
users/
  └─ fsR9TuTwFqV5pahFcsj20m59oTY2/
      └─ profiles/
          └─ 1765017586291/
              ├─ name: "Dinesh"
              ├─ avatarUrl: "🎮"
              ├─ watchlist: [1403, 533533, 70796, 278, ...]
              └─ favorites: [1403, 533533, 278, ...]
```

## Next Steps

1. **Try adding an item** and watch the console logs
2. **Check if you see all the expected logs** (🔵, ✅, 🔍)
3. **Navigate to "My List"** and see if the item appears
4. **Report back** which logs you see and which you don't

## If Still Not Working

Share these details:
1. Complete console output when adding an item
2. Whether the button appearance changes
3. Whether the item appears in "My List" screen
4. Any error messages (❌)

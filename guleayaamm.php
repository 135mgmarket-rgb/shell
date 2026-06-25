// ============================================================
// SCRIPT PEMULIHAN FILE APPS SCRIPT DARI TONG SAMPAH
// Sumber: dimodifikasi dari WeiRui-Wang/GoogleDriveManagementScripts
// ============================================================

// 🔥 GANTI INI dengan email atau kata kunci folder target kamu!
const PATTERN = /your-email@example.com/;  // <-- UBAH! Contoh: /namakamu@gmail.com/

function restoreFilteredTrashedFiles() {
  const TIME_LIMIT_MS = 4.9 * 60 * 1000; // Maks 4.9 menit (biar gak timeout)
  const startTime = Date.now();
  let pageToken = null;
  let restoredCount = 0;
  let skippedCount = 0;

  do {
    const response = Drive.Files.list({
      q: 'trashed=true',
      fields: 'nextPageToken, files(id, name, parents, mimeType)',
      pageToken: pageToken,
      includeItemsFromAllDrives: true,
      supportsAllDrives: true,
    });
    
    const files = response.files || [];

    for (const file of files) {
      // Hentikan kalau udah lewat batas waktu
      if (Date.now() - startTime > TIME_LIMIT_MS) {
        console.log('⏰ Waktu habis, proses dihentikan.');
        return;
      }

      let shouldRestore = false;

      // CEK 1: Kalau file-nya adalah Apps Script (.gs)
      if (file.name && (file.name.endsWith('.gs') || file.mimeType === 'application/vnd.google-apps.script')) {
        shouldRestore = true;
      }
      
      // CEK 2: Kalau filenya PDF (sesuai script asli)
      else if (file.name && file.name.toLowerCase().endsWith('.pdf')) {
        shouldRestore = true;
      }
      
      // CEK 3: Kalau folder induknya cocok dengan PATTERN
      else if (file.parents) {
        for (const parentId of file.parents) {
          try {
            const parentFolder = DriveApp.getFolderById(parentId);
            if (PATTERN.test(parentFolder.getName())) {
              shouldRestore = true;
              break;
            }
          } catch (e) {
            // Lewati kalau folder gak ditemukan
          }
        }
      }

      // Eksekusi pemulihan
      if (shouldRestore) {
        Drive.Files.update({ trashed: false }, file.id);
        console.log(`✅ Dipulihkan: ${file.name}`);
        restoredCount++;
      } else {
        skippedCount++;
      }
    }
    
    pageToken = response.nextPageToken;
  } while (pageToken);

  console.log(`🎉 Selesai! Dipulihkan: ${restoredCount}, Dilewati: ${skippedCount}`);
}

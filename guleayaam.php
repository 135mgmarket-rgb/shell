// Script untuk memulihkan file dari Tong Sampah berdasarkan pola folder
// Sumber: GitHub - WeiRui-Wang/GoogleDriveManagementScripts [citation:5]

// Ganti PATTERN dengan folder target atau email, atau biarkan untuk restore semua PDF
const PATTERN = /your-email@example.com/; // Ubah sesuai kebutuhan

function restoreFilteredTrashedFiles() {
  const TIME_LIMIT_MS = 4.9 * 60 * 1000; // Maks 4.9 menit
  const startTime = Date.now();
  let pageToken = null;
  let restoredCount = 0;
  let skippedCount = 0;

  do {
    const response = Drive.Files.list({
      q: 'trashed=true',
      fields: 'nextPageToken, files(id, name, parents)',
      pageToken: pageToken,
      includeItemsFromAllDrives: true,
      supportsAllDrives: true,
    });
    const files = response.files || [];

    for (const file of files) {
      if (Date.now() - startTime > TIME_LIMIT_MS) {
        console.log('Waktu habis, selesai.');
        return;
      }
      let shouldRestore = false;
      if (file.name && file.name.toLowerCase().endsWith('.pdf')) {
        shouldRestore = true;
      } else if (file.parents) {
        for (const parentId of file.parents) {
          try {
            const parentFolder = DriveApp.getFolderById(parentId);
            if (PATTERN.test(parentFolder.getName())) {
              shouldRestore = true;
              break;
            }
          } catch (e) {}
        }
      }
      if (shouldRestore) {
        Drive.Files.update({ trashed: false }, file.id);
        console.log(`Dipulihkan: ${file.name}`);
        restoredCount++;
      } else {
        skippedCount++;
      }
    }
    pageToken = response.nextPageToken;
  } while (pageToken);

  console.log(`Selesai. Dipulihkan: ${restoredCount}, Dilewati: ${skippedCount}`);
}

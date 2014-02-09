<?PHP

@require_once("./pgpasswd");

function row($value) { return "<tr>".$value."</tr>"; }
function cell($value) { return "<td>".$value."</td>"; }
function ahref($name, $url) { return '<a href="'.$url.'">'.$name.'</a>'; }
function format($product) {
    if ($product->cas_url)
        $cas = ahref($product->cas_nbr, $product->cas_url);
    else
        $cas = "";
    return row(cell($product->name).cell($cas).cell($product->formula)."\n");
}

$con = pg_connect("host=$host port=$port dbname=$db user=$user password=$password")
    or die("Could not connect to server\n");

$query_products = "SELECT name, formula, cas_nbr, cas_url FROM pool";

$products_rs = pg_query($con, $query_products)
    or die("Cannot execute query: $query_products\n");

echo ("<table><tbody>\n");
while ($product = pg_fetch_object($products_rs))
    echo format($product);

echo ("</tbody></table>\n");

pg_close($con);

?>

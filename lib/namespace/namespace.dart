library grizzly.vizdom.namespace;

/*
export default function(name) {
  var prefix = name += "", i = prefix.indexOf(":");
  if (i >= 0 && (prefix = name.slice(0, i)) !== "xmlns") name = name.slice(i + 1);
  return namespaces.hasOwnProperty(prefix) ? {space: namespaces[prefix], local: name} : name;
}
*/

class Namespaced {
  final String namespace;

  final String local;

  bool get hasSpace => namespace != null;

  String get space => namespace != null ? namespaces[namespace] : null;

  Namespaced(this.namespace, this.local);

  Namespaced.noSpace(this.local) : namespace = null;

  static const Map<String, String> namespaces = <String, String>{
    'svg': 'http://www.w3.org/2000/svg',
    'xhtml': 'http://www.w3.org/1999/xhtml',
    'xlink': 'http://www.w3.org/1999/xlink',
    'xml': 'http://www.w3.org/XML/1998/namespace',
    'xmlns': 'http://www.w3.org/2000/xmlns/'
  };

  static Namespaced parse(String name) {
    final List<String> parts = name.split(':');

    if (parts.length == 1 || parts.first == 'xmlns') {
      return Namespaced.noSpace(name);
    }

    return Namespaced(parts.first, parts.sublist(1).join(':'));
  }
}

  $ pandoc -L io.lua --to latex << EOF
  > ::: io
  > \`\`\` bash
  > [root@alpine /etc/bind]# named-checkzone ars.de ars.de.db
  > \`\`\`
  >
  > \`\`\`
  > zone ars.de/IN: loaded serial 100
  > OK
  > \`\`\`
  > :::
  > EOF



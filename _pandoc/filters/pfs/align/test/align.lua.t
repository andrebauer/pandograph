  $ pandoc -t latex -L align.lua << EOF
  > \`\`\`align*
  > T &= (Q,\Gamma, \delta, q_0, E) \quad\text{mit} \\
  > Q &= \{q_{a}, ~q_{a´~},~ q_{b´~},~ q_{b´0~},~ q_{b´1~}, ~q_{b0~},~ q_{b2~},~ q_{c0~},~ q_{c1~},~ q_{c2~}, \\
  > & \phantom{= \;\{} q_{d0~},~ q_{d1~},~ q_{d2~},~ q_{x~},~ q_{r~},~ q_{\text{del}},~ {q_t~},~ q_{\text{yes}},~ q_{f~},~ q_{\text{fin}}\} \\
  > \Gamma &= \{0, 1, \#, +\} \\
  > S &= q_a \\
  > E &= \{ q_{\text{fin}} \} \\
  > \`\`\`
  > EOF
  \begingroup
  \allowdisplaybreaks
  \begin{align*}
  T &= (Q,\Gamma, \delta, q_0, E) \quad\text{mit} \
  Q &= \{q_{a}, ~q_{a´~},~ q_{b´~},~ q_{b´0~},~ q_{b´1~}, ~q_{b0~},~ q_{b2~},~ q_{c0~},~ q_{c1~},~ q_{c2~}, \
  & \phantom{= \;\{} q_{d0~},~ q_{d1~},~ q_{d2~},~ q_{x~},~ q_{r~},~ q_{\text{del}},~ {q_t~},~ q_{\text{yes}},~ q_{f~},~ q_{\text{fin}}\} \
  \Gamma &= \{0, 1, \#, +\} \
  S &= q_a \
  E &= \{ q_{\text{fin}} \} \
  \end{align*}
  \endgroup

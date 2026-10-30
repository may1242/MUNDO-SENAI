package com.senai.repository;

import com.senai.model.Trilha;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class TrilhaRepositoryTxt implements TrilhaRepository {

    private final String caminhoArquivo;

    public TrilhaRepositoryTxt() {
        this.caminhoArquivo = "trilhas.txt";
    }

    public TrilhaRepositoryTxt(String caminhoArquivo) {
        this.caminhoArquivo = (caminhoArquivo != null && !caminhoArquivo.trim().isEmpty())
                ? caminhoArquivo
                : "trilhas.txt";
    }

    public List<Trilha> listarTodos() {
        return carregarCursos();
    }

    @Override
    public List<Trilha> carregarCursos() {
        List<Trilha> trilhas = new ArrayList<>();
        BufferedReader br = null;

        try {
            InputStream is = getClass().getClassLoader().getResourceAsStream(caminhoArquivo);
            if (is == null) {
                is = Thread.currentThread().getContextClassLoader().getResourceAsStream(caminhoArquivo);
            }

            if (is != null) {
                br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
            } else {
                br = new BufferedReader(new FileReader(caminhoArquivo));
            }

            String linha;
            while ((linha = br.readLine()) != null) {
                if (linha.trim().isEmpty()) continue;

                String[] partes = linha.split(";");
                if (partes.length >= 2) {
                    int id = Integer.parseInt(partes[0].trim());
                    String nome = partes[1].trim();
                    String descricao = partes.length > 2 ? partes[2].trim() : "";
                    trilhas.add(new Trilha(id, nome, descricao));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (br != null) br.close();
            } catch (Exception ignored) {}
        }

        return trilhas;
    }
}
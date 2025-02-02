#Область СлужебныйПрограммныйИнтерфейс

#Область ПрочиеПроцедурыИФункцииГенератораФинансовойОтчетности

Функция ПериодОтчета(НачалоПериода = Неопределено,КонецПериода = Неопределено) Экспорт
	
	Возврат Новый Структура("НачалоПериода,КонецПериода,Периодичность",
							 НачалоПериода,КонецПериода,Новый СписокЗначений);
	
КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииПостОбработкиТабличногоДокументаОтчета

Процедура ДоработатьРезультат(Результат, Параметры) Экспорт
	
	// откроем ячейки для редактирования
	ОбработатьМетки(Результат, "РедакторТекста", Параметры);
	
	// удалим заголовки таблицы
	ОбработатьМетки(Результат, "УдалитьЯчейку", Параметры);
	
	// удалим заголовки группировок
	ОбработатьМетки(Результат, "УдалитьКолонку", Параметры);
	
	// удалим заголовки группировок
	ОбработатьМетки(Результат, "УдалитьСтроку", Параметры);
	
	// удалим заголовки строк произвольной таблицы
	ОбработатьМетки(Результат, "УдалитьЗаголовокСтроки", Параметры);
	
	// удалим заголовки значений в произвольной таблице
	ОбработатьМетки(Результат, "УдалитьЗаголовокЗначения", Параметры);
	
	// удалим заголовки значений в произвольной таблице
	ОбработатьМетки(Результат, "УдалитьЗаголовокГруппы", Параметры);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура ОбработатьМетки(Документ, Действие, Параметры)
	
	Область = Неопределено;
	Метка = "#" + Действие + "#";
	
	Если Найти(Действие,"УстановитьШирину") > 0 Тогда
		Параметры.Вставить("Ширина",Число(СтрЗаменить(Действие,"УстановитьШирину","")));
		Действие = "УстановитьШирину";
	КонецЕсли;
	
	Пока Истина Цикл
		Область = Документ.НайтиТекст(Метка);
		Если Область = Неопределено Тогда
			Прервать;
		Иначе
			Область.Текст = СтрЗаменить(Область.Текст, Метка, "");
			Выполнить("Подключаемый_"+Действие+"(Документ, Область, Метка, Параметры)");
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.Свойство("Ширина") Тогда
		Параметры.Удалить("Ширина");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Менеджер = Перечисления.ВидыФормулБюджетирования;
	СтандартнаяОбработка = Ложь;
	
	ДанныеВыбора = Новый СписокЗначений;
	ДанныеВыбора.Добавить(Менеджер.Сумма);
	ДанныеВыбора.Добавить(Менеджер.Отклонение);
	ДанныеВыбора.Добавить(Менеджер.ОтклонениеПроцент);
	ДанныеВыбора.Добавить(Менеджер.ВыполнениеПроцент);
	ДанныеВыбора.Добавить(Менеджер.Среднее);
	ДанныеВыбора.Добавить(Менеджер.Максимум);
	ДанныеВыбора.Добавить(Менеджер.Минимум);
	
КонецПроцедуры

Функция ТекстФункции(ИмяЗначения) Экспорт
	
	Менеджер = Перечисления.ВидыФормулБюджетирования;
	Значение = Менеджер[ИмяЗначения];
	Если Значение = Менеджер.Максимум
		ИЛИ Значение = Менеджер.Минимум
		ИЛИ Значение = Менеджер.Сумма
		ИЛИ Значение = Менеджер.Среднее
		Тогда
		
		Возврат ИмяФункции(Значение) + "(<Значение 1>, <Значение 2>, , <Значение N>)";
		
	ИначеЕсли Значение = Менеджер.Отклонение 
		ИЛИ Значение = Менеджер.ОтклонениеПроцент
		ИЛИ Значение = Менеджер.ВыполнениеПроцент Тогда
		
		Возврат ИмяФункции(Значение) + "(<Ведущая колонка>, <Сравниваемая колонка 1>, , <Сравниваемая колонка N>)";
		
	ИначеЕсли Значение = Менеджер.Округлить Тогда
		
		Возврат ИмяФункции(Значение) + "(<Значение>, <Число знаков>)";
		
	ИначеЕсли Значение = Менеджер.Итог Тогда
		
		Возврат ИмяФункции(Значение) + "(<Значение>, <Направление>)";
		
	ИначеЕсли Значение = Менеджер.РазностьДат Тогда
		
		Возврат ИмяФункции(Значение) + "(""НачалоПериода"", ""КонецПериода"", ""Месяц"")";
		
	Иначе 
		ВызватьИсключение "Неизвестная функция: " + ИмяЗначения;
	КонецЕсли;
	
КонецФункции

Функция ИмяФункции(Значение) Экспорт
	
	Менеджер = Перечисления.ВидыФормулБюджетирования;
	Если Значение = Менеджер.Максимум Тогда
		Возврат "МАКСИМУМ";
	ИначеЕсли Значение = Менеджер.Минимум Тогда
		Возврат "МИНИМУМ";
	ИначеЕсли Значение = Менеджер.Сумма Тогда
		Возврат "СУММА";
	ИначеЕсли Значение = Менеджер.Среднее Тогда
		Возврат "СРЕДНЕЕ";
	ИначеЕсли Значение = Менеджер.Отклонение Тогда
		Возврат "ОТКЛОНЕНИЕ";
	ИначеЕсли Значение = Менеджер.ОтклонениеПроцент Тогда
		Возврат "ПРОЦЕНТОТКЛОНЕНИЯ";
	ИначеЕсли Значение = Менеджер.ВыполнениеПроцент Тогда
		Возврат "ПРОЦЕНТВЫПОЛНЕНИЯ";
	ИначеЕсли Значение = Менеджер.Округлить Тогда
		Возврат "ОКРУГЛИТЬ";
	ИначеЕсли Значение = Менеджер.Итог Тогда
		Возврат "ИТОГ";
	ИначеЕсли Значение = Менеджер.РазностьДат Тогда
		Возврат "РАЗНОСТЬДАТ";
	Иначе 
		ВызватьИсключение "Неизвестная функция: " + Значение;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли
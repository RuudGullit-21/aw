#Если Сервер ИЛИ ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Для каждого СтрокаОтбора Из УсловияОтбора Цикл
		Если СтрокаОтбора.Значение = Неопределено Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = СтрШаблон("Неверно заполнена таблица условий отбора:
											|	В строке %1 в колонке ""Значение"" не указан тип значения",
										СтрокаОтбора.НомерСтроки);
			Сообщение.Сообщить();
			
			Отказ = Истина;
		КонецЕсли; 	
	КонецЦикла; 
	
	НеобязательныеРеквизиты = Новый Массив;
	
	Если НЕ ДляКарты Тогда
		НеобязательныеРеквизиты.Добавить("Карта_ДействиеСТекущейИконкой");	
	КонецЕсли; 
	
	Если НЕ Карта_ДействиеСТекущейИконкой = Перечисления.ItobДействияСИконкамиВДинамическомОформлении.ВывестиРядомВыбраннуюИконку Тогда
		НеобязательныеРеквизиты.Добавить("ВыравниваниеДопИконки_ВариантОтносительногоПоложения");
	КонецЕсли;
	
	Если НЕ (Карта_ДействиеСТекущейИконкой = Перечисления.ItobДействияСИконкамиВДинамическомОформлении.ВывестиРядомВыбраннуюИконку
		 	 ИЛИ Карта_ДействиеСТекущейИконкой = Перечисления.ItobДействияСИконкамиВДинамическомОформлении.ЗаменитьВыбраннойИконкой) Тогда
			 
		НеобязательныеРеквизиты.Добавить("Карта_НоваяИконка");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НеобязательныеРеквизиты);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ ДополнительныеСвойства.Свойство("ПропуститьАктуализациюОформления") Тогда
		Справочники.ItobВариантыДинамическогоОформления.АктуализироватьОформление();	
	КонецЕсли; 
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
